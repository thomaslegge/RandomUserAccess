//
//  Extensions.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation

extension String {
    /// Referenced from https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string by Paul Hudson @twostraws May 28th 2019
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    /// End Reference
}
