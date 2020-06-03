//
//  UserTableViewController.swift
//  RandomUserAccess
//
//  Created by Thomas Legge on 3/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    @IBOutlet weak var scrollRefreshControll: UIRefreshControl!
    
    @IBAction func userRefresh(_ sender: UIRefreshControl) {
        updateUserData(search: "refresh")
    }
    
    var displayUsers: [User]?
    var completeUsers: [User]?
    
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
        // Safely Unwrap, if empty no need to search
        guard let users = self.completeUsers else {
            updateDisplay()
            return
        }
        
        UsersViewModel.SearchUsers(search: search, users: users) { result in
            self.displayUsers = result
            self.updateDisplay()
        }
    }
    
    func refreshUsersDisplaying() {
        self.displayUsers = self.completeUsers
        updateDisplay()
    }
    
    func updateDisplay() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table Updater
    
    func updateUserData(search: String?) {
        
        //        if search == nil {
        //            refreshUsersDisplaying()
        //            return
        //        }
        
        //#TODO run once and cache
        UsersViewModel.WebRequestUsers { result in
            switch result {
            case .failure(let error):
                print("UsersViewModel Error: ", error)
            case .success(let users):
                self.displayUsers = users
                self.completeUsers = users
                
                // Main thread for UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollRefreshControll.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayUsers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTabelViewCell", for: indexPath) as! UserTableViewCell
        
        cell.setCellData(user: (displayUsers?[indexPath.row])!)
        
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
            (segue.destination as! UserDetailViewController).user = displayUsers?[self.tableView.indexPathForSelectedRow!.row]
        }
        //#TODO
        //         if(segue.identifier == "filterView") {
        //             (segue.destination as! VC_SetFilter).applyFilter = applyFilter
        //         }
    }
}
