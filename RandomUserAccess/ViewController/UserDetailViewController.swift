//
//  UserDetailViewController.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    var user : User?

    @IBOutlet weak var userImageLarge: UIImageView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userSubtitleLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTitleLabel.text = (user?.name?.title)! + " " + (user?.name?.first)! + " " + (user?.name?.last)!
        userSubtitleLabel.text = (user?.gender)!.capitalizingFirstLetter() + " : " + (user?.dob?.date)!
        userPhoneLabel.text = user?.phone
        userEmailLabel.text = user?.email

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
