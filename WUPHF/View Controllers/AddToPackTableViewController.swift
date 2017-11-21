//
//  ContactsTableViewController.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddtoPackTableViewController: UITableViewController {
    
    private var contacts: [User] = []
    var selectedUser: User!
    var pack: Pack!
    var allPacks: [Pack]!
    //private var selectedUser: User?
    
    override func viewDidAppear(_ animated: Bool) {
        APIHandler.shared.getFriends(id: Common.loggedInUser!.id) { (users) in
            self.contacts = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! AddToPackTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.sendInfo(user: contacts[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedUser = contacts[indexPath.item]
        }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SendWuphf" {
            if let indexPath = self.tableView.indexPath(for: sender as! ContactTableViewCell){
                let tempController = segue.destination as? UINavigationController
                let vc = tempController?.topViewController as! SendWUPHFViewController
                vc.target = contacts[indexPath.row - 1]
            }
        }
    }
    
    
}

