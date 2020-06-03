//
//  UserTableViewModel.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation
import CoreData

struct UsersViewModel {
    enum UserError: Error {
        case noDataAvailable
        case cannotProccesData
    }
    
    static func WebRequestUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        //#TODO: improve url building
        let urlString = "https://randomuser.me/api/?results=4"
        
        guard let url = URL(string: urlString) else {fatalError("Invalid URL")}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results!))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func SearchUsers(search : String, users: [NSManagedObject], completion: @escaping ([NSManagedObject]) -> ()) {
        var results:[NSManagedObject] = []
        let search = search.lowercased()
        
        for user in users {
            let firstName = (user.value(forKeyPath: "firstName") as! String).lowercased()
            let lastName = (user.value(forKeyPath: "lastName") as! String).lowercased()
            
            if  firstName.contains(search) || lastName.contains(search) {
                results.append(user)
            }
        }
        completion(results)
    }
    
    // TODO: - Refactor load/save from vc to here
    
    //    static func WriteToLocal(name: String) {
    //
    //      guard let appDelegate =
    //        UIApplication.shared.delegate as? AppDelegate else {
    //        return
    //      }
    //
    //      // 1
    //      let managedContext =
    //        appDelegate.persistentContainer.viewContext
    //
    //      // 2
    //      let entity =
    //        NSEntityDescription.entity(forEntityName: "Person",
    //                                   in: managedContext)!
    //
    //      let person = NSManagedObject(entity: entity,
    //                                   insertInto: managedContext)
    //
    //      // 3
    //      person.setValue(name, forKeyPath: "name")
    //
    //      // 4
    //      do {
    //        try managedContext.save()
    //        people.append(person)
    //      } catch let error as NSError {
    //        print("Could not save. \(error), \(error.userInfo)")
    //      }
    //    }
}
