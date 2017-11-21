//
//  ContactsTableViewController.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddtoPackTableViewController: UITableViewController, AddUserToPack {

    private var contacts: [User] = []
    var pack: Pack?
    var delegate: UpdatePackList?
    
    override func viewDidAppear(_ animated: Bool) {
        APIHandler.shared.getFriends(id: Common.loggedInUser!.id) { (users) in
            self.contacts = []
            for user in users {
                if !self.pack!.members.contains(user.id) {
                    self.contacts.append(user)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "addContactToPack", for: indexPath) as! AddToPackTableViewCell
        cell.sendInfo(user: contacts[indexPath.item], pack: pack!, delegate: self)
        cell.selectionStyle = .none
        return cell
    }
    
    func addUserToPack(user: User, pack: Pack) {
        pack.members.append(user.id)
        // Update persistence async
        pack.writePack()
        // Go back
        delegate?.updateListAndGoBack()
    }
    
}

protocol UpdatePackList {
    func updateListAndGoBack()
}

