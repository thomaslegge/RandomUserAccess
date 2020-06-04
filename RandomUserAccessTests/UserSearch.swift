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

class UserSearch: XCTestCase {
    
    let testUserString =
    """
    {
        "results": [
            {
                "gender": "male",
                "name": {
                    "title": "Monsieur",
                    "first": "Lorik",
                    "last": "Michel"
                },
                "location": {
                    "street": {
                        "number": 4260,
                        "name": "Rue des Chartreux"
                    },
                    "city": "Anières",
                    "state": "Vaud",
                    "country": "Switzerland",
                    "postcode": 7487,
                    "coordinates": {
                        "latitude": "-50.7808",
                        "longitude": "-55.7270"
                    },
                    "timezone": {
                        "offset": "-1:00",
                        "description": "Azores, Cape Verde Islands"
                    }
                },
                "email": "lorik.michel@example.com",
                "login": {
                    "uuid": "9b66b0e6-2ce4-4847-950d-1726b59156f5",
                    "username": "angrysnake198",
                    "password": "emily",
                    "salt": "kU3rFrE3",
                    "md5": "bd41aacc9f21014af6ed77af156c7f19",
                    "sha1": "4427ca0431c14555d7876e03f7841666448f1f57",
                    "sha256": "c3abd0bfe2b405a9db889bbd71f540fc52fbc9087423dfb1faced57a00fb9f8c"
                },
                "dob": {
                    "date": "1968-09-23T22:36:24.114Z",
                    "age": 52
                },
                "registered": {
                    "date": "2004-10-24T19:53:48.847Z",
                    "age": 16
                },
                "phone": "076 613 49 31",
                "cell": "076 054 41 56",
                "id": {
                    "name": "AVS",
                    "value": "756.1807.3683.93"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/40.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/40.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/40.jpg"
                },
                "nat": "CH"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Albert",
                    "last": "Petersen"
                },
                "location": {
                    "street": {
                        "number": 2701,
                        "name": "Markedsgade"
                    },
                    "city": "Haslev",
                    "state": "Midtjylland",
                    "country": "Denmark",
                    "postcode": 24052,
                    "coordinates": {
                        "latitude": "-58.4384",
                        "longitude": "-101.4471"
                    },
                    "timezone": {
                        "offset": "-9:00",
                        "description": "Alaska"
                    }
                },
                "email": "albert.petersen@example.com",
                "login": {
                    "uuid": "087729a1-d0b5-4ad5-a551-0c1484620101",
                    "username": "ticklishsnake742",
                    "password": "purdue",
                    "salt": "bgcgkbXW",
                    "md5": "d2f4ecd9c62883f72cec46ed3d881ba6",
                    "sha1": "ff32fb384365b65e6cce04fdec2576a37d4b5c43",
                    "sha256": "2ac1a2c86df45307372159b7d83e7ef2e242030246f633d2a8dce35088de202a"
                },
                "dob": {
                    "date": "1970-08-07T14:44:41.007Z",
                    "age": 50
                },
                "registered": {
                    "date": "2016-07-30T06:44:46.737Z",
                    "age": 4
                },
                "phone": "08380013",
                "cell": "46790080",
                "id": {
                    "name": "CPR",
                    "value": "070870-3100"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/97.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/97.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/97.jpg"
                },
                "nat": "DK"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Barry",
                    "last": "Allen"
                },
                "location": {
                    "street": {
                        "number": 2566,
                        "name": "W Dallas St"
                    },
                    "city": "Australian Capital Territory",
                    "state": "New South Wales",
                    "country": "Australia",
                    "postcode": 7235,
                    "coordinates": {
                        "latitude": "-60.2237",
                        "longitude": "-168.6980"
                    },
                    "timezone": {
                        "offset": "+3:30",
                        "description": "Tehran"
                    }
                },
                "email": "barry.allen@example.com",
                "login": {
                    "uuid": "ccbddb7d-f0d5-4d11-9579-ce10c1520102",
                    "username": "organiczebra255",
                    "password": "cable",
                    "salt": "bQZkWDT3",
                    "md5": "c8e8e5c886c4759fec5415ecef4554d3",
                    "sha1": "45fcc77e1d800070548cb2094115bae4eb719b1b",
                    "sha256": "6ec68edabddeae51db8b34d75c391b752279f105d36ebd641d431f16cfa12f5a"
                },
                "dob": {
                    "date": "1967-03-28T06:54:51.528Z",
                    "age": 53
                },
                "registered": {
                    "date": "2014-01-03T10:26:09.601Z",
                    "age": 6
                },
                "phone": "08-7208-8400",
                "cell": "0400-427-750",
                "id": {
                    "name": "TFN",
                    "value": "873454847"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/35.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/35.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/35.jpg"
                },
                "nat": "AU"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Ms",
                    "first": "Brielle",
                    "last": "Ouellet"
                },
                "location": {
                    "street": {
                        "number": 3887,
                        "name": "15th St"
                    },
                    "city": "Sidney",
                    "state": "Québec",
                    "country": "Canada",
                    "postcode": "D9H 3V5",
                    "coordinates": {
                        "latitude": "-75.8687",
                        "longitude": "-177.1693"
                    },
                    "timezone": {
                        "offset": "+3:30",
                        "description": "Tehran"
                    }
                },
                "email": "brielle.ouellet@example.com",
                "login": {
                    "uuid": "94e12d0b-d2c7-4be3-9f26-a5cb31de7101",
                    "username": "purplesnake746",
                    "password": "tech",
                    "salt": "1u2LHbyW",
                    "md5": "56285595ab7b90722c4f0827f748209d",
                    "sha1": "640c4dbd32be5b5927e00b8fdf94b9b7286fd8dd",
                    "sha256": "a87adbdc7ac04c8d7817d93c32fb7cc5ab26b9b4a3c1136c186e33e658fe1947"
                },
                "dob": {
                    "date": "1956-07-22T12:08:46.150Z",
                    "age": 64
                },
                "registered": {
                    "date": "2014-01-12T04:25:15.455Z",
                    "age": 6
                },
                "phone": "048-699-5696",
                "cell": "837-054-4281",
                "id": {
                    "name": "",
                    "value": null
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/53.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/53.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/53.jpg"
                },
                "nat": "CA"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Filippa",
                    "last": "Hagberg"
                },
                "location": {
                    "street": {
                        "number": 5212,
                        "name": "Josefines gate"
                    },
                    "city": "Heggenes",
                    "state": "Rogaland",
                    "country": "Norway",
                    "postcode": "0771",
                    "coordinates": {
                        "latitude": "-86.4542",
                        "longitude": "-3.9203"
                    },
                    "timezone": {
                        "offset": "-12:00",
                        "description": "Eniwetok, Kwajalein"
                    }
                },
                "email": "filippa.hagberg@example.com",
                "login": {
                    "uuid": "3bc80db5-686d-46cb-a93b-a960cc1d5d98",
                    "username": "beautifulostrich669",
                    "password": "hole",
                    "salt": "AkMqYjsa",
                    "md5": "6c140c906e5cb324dde5728e42036397",
                    "sha1": "3d4930c2e7a84310ff3a7da9cfd366bfcdc5ff10",
                    "sha256": "739799bc92497e2c4f751f00c583ef32860baac2cd29895cb49d3071c3f219be"
                },
                "dob": {
                    "date": "1961-04-19T00:44:03.622Z",
                    "age": 59
                },
                "registered": {
                    "date": "2011-03-25T08:55:39.682Z",
                    "age": 9
                },
                "phone": "29667911",
                "cell": "43919697",
                "id": {
                    "name": "FN",
                    "value": "19046131269"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/70.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/70.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/70.jpg"
                },
                "nat": "NO"
            }
        ],
        "info": {
            "seed": "b189f3235cfbb65a",
            "results": 5,
            "page": 1,
            "version": "1.3"
        }
    }
    """.data(using: .utf8)!
    
    var users: [NSManagedObject] = []

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
        
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
        let container = persistentContainer

        for user in response.results! {
            let managedContext = container.viewContext
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
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredUser")
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func tearDownWithError() throws {
        deleteAllData("StoredUser")
    }
    
    func testReturnZeroSearchW() throws {
        UsersViewModel.SearchUsersNames(search: "w", users: users) { result in
            XCTAssert(result.count == 0)
        }
    }

    func testReturnOneSearchPP() throws {
        UsersViewModel.SearchUsersNames(search: "pp", users: users) { result in
            XCTAssert(result.count == 1)
        }
    }
    
    func testReturnTwoSearchT() throws {
        UsersViewModel.SearchUsersNames(search: "t", users: users) { result in
            XCTAssert(result.count == 2)
            print(result.count)
        }
    }
    
    func testReturnThreeSearchA() throws {
        UsersViewModel.SearchUsersNames(search: "a", users: users) { result in
            XCTAssert(result.count == 3)
        }
    }
    
    func testReturnFourSearchB() throws {
        UsersViewModel.SearchUsersNames(search: "b", users: users) { result in
            XCTAssert(result.count == 4)
        }
    }
    
    func testReturnFiveSearchE() throws {
        UsersViewModel.SearchUsersNames(search: "e", users: users) { result in
            XCTAssert(result.count == 5)
        }
    }
    
    func testNoneSearch() throws {
        UsersViewModel.SearchUsersNames(search: "", users: users) { result in
            XCTAssert(result.count == 0)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
