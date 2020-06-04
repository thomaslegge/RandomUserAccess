//
//  UserSearch.swift
//  RandomUserAccessTests
//
//  Created by Thomas Legge on 4/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import XCTest
import CoreData
@testable import RandomUserAccess

class UserStorage: XCTestCase {
    
    let testUserString =
    """
    {
        "results": [
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Isabella",
                    "last": "Johansen"
                },
                "location": {
                    "street": {
                        "number": 6071,
                        "name": "Havremarken"
                    },
                    "city": "Viby Sj.",
                    "state": "Hovedstaden",
                    "country": "Denmark",
                    "postcode": 88738,
                    "coordinates": {
                        "latitude": "-27.1194",
                        "longitude": "149.2914"
                    },
                    "timezone": {
                        "offset": "+4:30",
                        "description": "Kabul"
                    }
                },
                "email": "isabella.johansen@example.com",
                "login": {
                    "uuid": "643a94f3-ddf0-4d92-bbdf-942e7a7472bf",
                    "username": "yellowlion358",
                    "password": "stephen",
                    "salt": "Z8c2KiDR",
                    "md5": "9e6e1d49b775ae60bba25da1102e276a",
                    "sha1": "9f94ec0d63d168d191f0c24516c8efb3aff6eaad",
                    "sha256": "7c39f745a143342947a490d5792f5c197003aa3fcc3bafad72c47e1599aa9f0b"
                },
                "dob": {
                    "date": "1951-09-09T20:20:57.243Z",
                    "age": 69
                },
                "registered": {
                    "date": "2018-06-09T18:59:44.850Z",
                    "age": 2
                },
                "phone": "64241793",
                "cell": "96710817",
                "id": {
                    "name": "CPR",
                    "value": "090951-3542"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/43.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/43.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/43.jpg"
                },
                "nat": "DK"
            }
        ],
        "info": {
            "seed": "93cd2aa66f23a40e",
            "results": 1,
            "page": 1,
            "version": "1.3"
        }
    }
    """.data(using: .utf8)!
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RandomUserAccess")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    override func setUpWithError() throws {
        deleteAllData("StoredUser")
        
        
    }

    override func tearDownWithError() throws {
        deleteAllData("StoredUser")
    }
    
    func testSaveUsersLocal() throws {
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
        
        ///Function Tested
        UsersViewModel.SaveUsersLocal(persistentContainer, users: response.results!)
        
        var completeStoredUsers: [NSManagedObject] = []
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredUser")
        do {
            completeStoredUsers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        XCTAssert(completeStoredUsers.count == 1)
    }
    
    func testLoadUsersLocal() throws {
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
    
        for user in response.results! {
            let managedContext = persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "StoredUser", in: managedContext)!
            let userToSave = NSManagedObject(entity: entity, insertInto: managedContext)
            
            userToSave.setValue(user.login?.uuid, forKey: "id")
            userToSave.setValue(user.name?.first, forKey: "firstName")
            userToSave.setValue(user.name?.last, forKey: "lastName")
            userToSave.setValue(user.name?.title, forKey: "titleName")
            userToSave.setValue(user.phone, forKey: "phoneNumber")
            userToSave.setValue(user.email, forKey: "email")
            userToSave.setValue(user.dob?.date, forKey: "dob")
            userToSave.setValue(user.gender, forKey: "gender")
            
            userToSave.setValue(user.picture?.thumbnail, forKey: "imageUrlSmall")
            userToSave.setValue(user.picture?.large, forKey: "imageUrlLarge")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        ///Function Tested
        UsersViewModel.LoadUserLocal(persistentContainer) {result in
            XCTAssert(result.count == 1)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
