//
//  UserTableViewCell.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(user : User) {
        titleLabel.text = (user.name?.title)! + " " + (user.name?.first)! + " " + (user.name?.last)!
        subtitleLabel.text = (user.gender)!.capitalizingFirstLetter() + " : " + (user.dob?.date)!
    }

}
