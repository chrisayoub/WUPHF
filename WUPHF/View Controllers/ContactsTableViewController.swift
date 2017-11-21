//
//  ContactsTableViewController.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    private var contacts: [User] = []
    private var selectedUser: User?
    
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
        return contacts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            // TODO: https://stackoverflow.com/questions/26129428/badge-view-in-uitableviewcell
            return tableView.dequeueReusableCell(withIdentifier: "pendingContactRequests", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.sendInfo(user: contacts[indexPath.item - 1])
        return cell
    }
    
    // https://developerslogblog.wordpress.com/2017/06/28/ios-11-swipe-leftright-in-uitableviewcell/
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.item == 0 {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "Delete",
                                              handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let friend = self.contacts.remove(at: indexPath.item - 1)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // Delete from server
            APIHandler.shared.deleteFriend(userId: Common.loggedInUser!.id, friendId: friend.id, completionHandler: nil)
            success(true)
        })
        modifyAction.title = "Delete"
        modifyAction.backgroundColor = .red
        
        let result = UISwipeActionsConfiguration(actions: [modifyAction])
        result.performsFirstActionWithFullSwipe = false
        return result
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item > 0 {
            print(selectedUser)
            selectedUser = contacts[indexPath.item - 1]
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SendWuphf" {
            if let indexPath = self.tableView.indexPath(for: sender){
                
                let tempController = segue.destination as? UINavigationController
                let vc = tempController?.topViewController as! SendWUPHFViewController
                    //segue.destination as! SendWUPHFViewController
                vc.target = contacts[indexPath.row-1]
                print(selectedUser)
            }
        }
    }

}
