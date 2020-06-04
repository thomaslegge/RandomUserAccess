//
//  UserDetailViewController.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit
import CoreData

/// Detail view displyed and labels set to given user values
class UserDetailViewController: UIViewController {
    
    var user: NSManagedObject?
    
    @IBOutlet weak var userImageLarge: UIImageView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userSubtitleLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set label values to given user
        let titleName = user!.value(forKeyPath: "titleName") as! String
        let firstName = user!.value(forKeyPath: "firstName") as! String
        let lastName = user!.value(forKeyPath: "lastName") as! String
        let title = "\(titleName) \(firstName) \(lastName)"
        
        let gender = user!.value(forKeyPath: "gender") as! String
        let dob = user!.value(forKeyPath: "dob") as! String
        let date = String(dob.prefix(10))
        
        let phone = user!.value(forKeyPath: "phoneNumber") as! String
        let email = user!.value(forKeyPath: "email") as! String
        
        userTitleLabel.text = title
        userSubtitleLabel.text = "\(gender.capitalizingFirstLetter()) \(date)"
        userPhoneLabel.text = phone
        userEmailLabel.text = email
        
        DispatchQueue.main.async {
            UsersViewModel.UserImageLarge(user: self.user!, imageView: self.userImageLarge)
        }
        
    }
}
