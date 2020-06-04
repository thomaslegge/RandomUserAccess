//
//  UserTableViewModel.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// Non view logic for handeling user data
struct UsersViewModel {
    /// Custom error types to return in request results
    enum UserError: Error {
        case noDataAvailable
        case cannotProccesData
    }
    
    /// Static function to retrive data from API and decode returned JSON users, escapes to work with result
    static func WebRequestUsers(completion: @escaping (Result<[User], Error>) -> ()) {
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
    
    /// Logic for searching given user list by first name
    static func SearchUsersNames(search : String, users: [NSManagedObject], completion: @escaping ([NSManagedObject]) -> ()) {
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
    
    // MARK: - Image downloading, cahcing, cache requesting
    /// Request saves and retrives images as needed and sets given UIImageView Accordingly
    private static func UserImageRequest(user: NSManagedObject, key: String, imageView: UIImageView) {
        if user.value(forKeyPath: key) == nil {
            
            var keyUrl = "imageUrlSmall"
            if key == "imageLarge" {
                keyUrl = "imageUrlLarge"
            }
            
            imageView.downloaded(from: user.value(forKeyPath: keyUrl) as! String) { result in
                switch result {
                case .failure(let error):
                    print("UsersViewModel Error: ", error)
                case .success( _):
                    // TODO: - Unwrap safety //Saving pre image before other image can populate
                    user.setValue(imageView.image!.jpegData(compressionQuality: 1.0), forKey: "imageSmall")
                }
            }
        } else {
            if let imageData = user.value(forKey: key) as? NSData {
                if let image = UIImage(data:imageData as Data) {
                    imageView.image = image
                }
            }
        }
    }
    
    /// Caller to use the image request on large images
    static func UserImageLarge(user: NSManagedObject, imageView: UIImageView) {
        UserImageRequest(user: user, key: "imageLarge", imageView: imageView)
    }
    
    /// Caller to use the image request on small images
    static func UserImageSmall(user: NSManagedObject, imageView: UIImageView) {
        UserImageRequest(user: user, key: "imageSmall", imageView: imageView)
    }
    
    /// Get NSPersistentContainer container from AppDelegate for CoreData use
    /// - Returns: NSPersistentContainer?
    private static func getPersistentContainer() -> NSPersistentContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer
    }
    
    // MARK: - Loading and Saving users locally
    /// Load stored user values
    /// - Parameter completion: on completion pass result of this fetch
    /// - Returns: @escaping [NSManagedObject]
    static func LoadUserLocal(_ container: NSPersistentContainer? = UsersViewModel.getPersistentContainer(), completion: @escaping ([NSManagedObject]) -> ()) {
        
        //Check container not nil
        guard let container = container else { return }
        
        var completeStoredUsers: [NSManagedObject] = []
        
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredUser")
        do {
            completeStoredUsers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        completion(completeStoredUsers)
    }
    
    /// Save given users array of type [User] to storage
    /// - Parameter user: [User] of values to save
    static func SaveUsersLocal(_ container: NSPersistentContainer? = UsersViewModel.getPersistentContainer(), users: [User]) {
        guard let container = container else { return }

        for user in users {
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
    }
}
