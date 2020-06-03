//
//  UserTableViewModel.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation

struct UsersViewModel {
    enum UserError: Error {
        case noDataAvailable
        case cannotProccesData
    }
        
    static func WebRequestUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        //#TODO: improve url building
        let urlString = "https://randomuser.me/api/?results=33"
        
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
    
    static func SearchUsers(search : String, users: [User], completion: @escaping ([User]?) -> ()) {
        var results:[User]?
        for user in users {
            if (user.name?.first!.contains(search))! || (user.name?.last!.contains(search))! {
                if (results?.append(user)) == nil {
                    results = [user]
                }
            }
        }
        completion(results)
    }
}
