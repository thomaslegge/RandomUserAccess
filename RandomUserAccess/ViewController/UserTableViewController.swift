//
//  UserTableViewController.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit
import CoreData

// TODO: - Refactor
struct Section {
    var letter : String
    var users : [NSManagedObject]
}

class UserTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var scrollRefreshControll: UIRefreshControl!
    @IBAction func userRefresh(_ sender: UIRefreshControl) {
        getUserData()
    }
    
    var completeStoredUsers: [NSManagedObject] = []
    var displayStoredUsers: [NSManagedObject] = []
    var userSectionsDisplay = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchBar.delegate = self
        
        if completeStoredUsers.count <= 0 {
            LoadUserLocal()
            if completeStoredUsers.count <= 0 {
                getUserData()
                return //Do not do redundant refresh
            }
        } else {
            return //Do not do redundant refresh
        }
        
        refreshUsersDisplaying()
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
    
    // MARK: - Refresh and update
    func refreshUsersDisplaying() {
        self.displayStoredUsers = self.completeStoredUsers
        updateDisplay()
    }
    
    func updateDisplay() {
        DispatchQueue.main.async {
            /// MARK: - TODO Refactor
            let groupedDictionary = Dictionary(grouping: self.displayStoredUsers, by: {String(($0.value(forKeyPath: "firstName") as! String).prefix(1))})
            // get the keys and sort them
            let keys = groupedDictionary.keys.sorted()
            self.userSectionsDisplay = keys.map{
                // Sort dict entries
                Section(letter: $0, users: groupedDictionary[$0]!.sorted { (first, second) -> Bool in
                    return second.value(forKeyPath: "firstName") as! String > first.value(forKeyPath: "firstName") as! String
                    }
                )
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Get Data
    func getUserData() {
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
                    self.scrollRefreshControll.endRefreshing()
                    self.refreshUsersDisplaying()
                }
            }
        }
    }
    
    // MARK: - Core Data
    func LoadUserLocal() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
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
        
        userToSave.setValue(user.picture?.thumbnail, forKey: "imageUrlSmall")
        userToSave.setValue(user.picture?.large, forKey: "imageUrlLarge")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTabelViewCell", for: indexPath) as! UserTableViewCell
        let user = userSectionsDisplay[indexPath.section].users[indexPath.row]
        cell.setCellData(user: user)
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSectionsDisplay[section].users.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userSectionsDisplay.count
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return userSectionsDisplay.map{$0.letter}
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userSectionsDisplay[section].letter
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userDetailView") {
            let section = userSectionsDisplay[self.tableView.indexPathForSelectedRow!.section]
            (segue.destination as! UserDetailViewController).user = section.users[self.tableView.indexPathForSelectedRow!.row]
        }
    }
}

// MARK: - Refactor

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return displayStoredUsers.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTabelViewCell", for: indexPath) as! UserTableViewCell
//
//        cell.setCellData(user: displayStoredUsers[indexPath.row])
//        //        cell.titleLabel.text = displayStoredUsers[indexPath.row].value(forKeyPath: "firstName") as? String
//
//        return cell
//    }

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
