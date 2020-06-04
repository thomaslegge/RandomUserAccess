//
//  Extensions.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// Capitalises the first letter of a string.
    /// Referenced from https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string by Paul Hudson @twostraws May 28th 2019
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIImageView {
    /// Downloads and displays an Image from the given link: String
    /// Completion allows multithreaded updates based on this functions results.
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: link) else { fatalError("Invalid URL") }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion(.success(data))
            }
        }.resume()
    }
}
