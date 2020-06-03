//
//  UserTableViewController.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit
import CoreData

class UserTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var scrollRefreshControll: UIRefreshControl!
    @IBAction func userRefresh(_ sender: UIRefreshControl) {
        updateUserData(search: "refresh")
    }
    
    var completeStoredUsers: [NSManagedObject] = []
    var displayStoredUsers: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchBar.delegate = self
        updateUserData(search: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Search Filter
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchString = userSearchBar.text, !searchString.isEmpty {
            searchFilterUpdate(search: searchString)
        } else {
            refreshUsersDisplaying()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = userSearchBar.text, !searchString.isEmpty {
            searchFilterUpdate(search: searchString)
        } else {
            refreshUsersDisplaying()
        }
    }

    func searchFilterUpdate(search: String) {
        UsersViewModel.SearchUsers(search: search, users: self.completeStoredUsers) { result in
            self.displayStoredUsers = result
            self.updateDisplay()
        }
    }

    func refreshUsersDisplaying() {
        self.displayStoredUsers = self.completeStoredUsers
        updateDisplay()
    }
    
    func updateDisplay() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table Updater
    
    func updateUserData(search: String?) {
        
        LoadUserLocal()
        self.tableView.reloadData()
        //#TODO run once and cache
        
        UsersViewModel.WebRequestUsers { result in
            switch result {
            case .failure(let error):
                print("UsersViewModel Error: ", error)
            case .success(let users):
                // Main thread for UI
                DispatchQueue.main.async {
                    for user in users {
                        self.SaveUserLocal(user: user)
                    }
                    self.LoadUserLocal()
                    
                    self.tableView.reloadData()
                    self.scrollRefreshControll.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Core Data
    
    func LoadUserLocal() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredUser")
        
        do {
            self.completeStoredUsers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        refreshUsersDisplaying()
    }
    
    // TODO: - Refactor
    func SaveUserLocal(user: User) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
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

        do {
            try managedContext.save()
            self.displayStoredUsers.append(userToSave)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        updateDisplay()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayStoredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTabelViewCell", for: indexPath) as! UserTableViewCell
        
        cell.setCellData(user: displayStoredUsers[indexPath.row])
//        cell.titleLabel.text = displayStoredUsers[indexPath.row].value(forKeyPath: "firstName") as? String
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userDetailView") {
            (segue.destination as! UserDetailViewController).user = displayStoredUsers[self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
