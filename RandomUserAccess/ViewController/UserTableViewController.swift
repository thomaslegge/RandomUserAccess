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
    /// Searches listed users or refreshes when empty
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchString = userSearchBar.text, !searchString.isEmpty {
            searchFilterUpdate(search: searchString)
        } else {
            refreshUsersDisplaying()
        }
    }

    /// Searches listed users or refreshes when empty
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = userSearchBar.text, !searchString.isEmpty {
            searchFilterUpdate(search: searchString)
        } else {
            refreshUsersDisplaying()
        }
    }
    
    /// Search on view model then store result and update display
    func searchFilterUpdate(search: String) {
        UsersViewModel.SearchUsersNames(search: search, users: self.completeStoredUsers) { result in
            self.displayStoredUsers = result
            self.updateDisplay()
        }
    }
    
    // MARK: - Refresh and update
    /// Return displayed valules to all values, allowing for dynamic search
    func refreshUsersDisplaying() {
        self.displayStoredUsers = self.completeStoredUsers
        updateDisplay()
    }
    
    /// Called often on thread to update list of users with correct sections
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
    /// Web request with static view model function to retrieve data from api
    func getUserData() {
        UsersViewModel.WebRequestUsers { result in
            switch result {
            case .failure(let error):
                print("UsersViewModel Error: ", error)
            case .success(let users):
                // Main thread for UI
                DispatchQueue.main.async {
                    self.SaveUsersLocal(users)
                    self.LoadUserLocal()
                    self.scrollRefreshControll.endRefreshing()
                    self.refreshUsersDisplaying()
                }
            }
        }
    }
    
    // MARK: - Core Data Helper
    /// Local Caller Helper for view model static func
    func LoadUserLocal() {
        UsersViewModel.LoadUserLocal() { result in
            self.completeStoredUsers = result
            self.refreshUsersDisplaying()
        }
    }
    
    /// Local Caller Helper for view model static func
    func SaveUsersLocal(_ users: [User]) {
        UsersViewModel.SaveUsersLocal(users: users)
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
