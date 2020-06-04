//
//  UserTableViewCell.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit
import CoreData

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(user : NSManagedObject) {
        
        let titleName = user.value(forKeyPath: "titleName") as! String
        let firstName = user.value(forKeyPath: "firstName") as! String
        let lastName = user.value(forKeyPath: "lastName") as! String
        let title = "\(titleName) \(firstName) \(lastName)"
        
        let gender = user.value(forKeyPath: "gender") as! String
        let dob = user.value(forKeyPath: "dob") as! String
        
        titleLabel.text = title
        subtitleLabel.text = "\(gender.capitalizingFirstLetter()) \(dob)"
        
        DispatchQueue.main.async {
            UsersViewModel.UserImageSmall(user: user, imageView: self.imageLabel)
        }
    }
}
