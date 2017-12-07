//
//  PackMembersTableViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackMembersTableViewController: UITableViewController, UpdatePackList {
    
    var pack: Pack!
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pack.name
        getUsers()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! PackMembersTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.sendInfo(user: users[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func getUsers() {
        self.users.removeAll()
        var totalFinish = 0
        for i in 0 ..< pack.members.count {
            APIHandler.shared.getUser(id: pack.members[i]) { (user) in
                if let userGood = user {
                    self.users.append(userGood)
                }
                totalFinish += 1
                if totalFinish == self.pack.members.count {
                    // Load data in table after done
                    self.tableView.reloadData()
                }
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendWuphf" {
            if let index = self.tableView.indexPath(for: sender as! PackMembersTableViewCell) {
                let tempController = segue.destination as? UINavigationController
                let vc = tempController?.topViewController as! SendWUPHFViewController
                vc.targetIds = [self.users[index.item].id]
            }
        }
        else if segue.identifier == "AddToPack" {
            let vc = segue.destination as! AddtoPackTableViewController
            vc.delegate = self
            vc.pack = self.pack
        }
    }
    
    func updateListAndGoBack() {
        // Update list
        getUsers()
        // Bring back
        navigationController?.popToViewController(self, animated: true)
    }
    
    // https://developerslogblog.wordpress.com/2017/06/28/ios-11-swipe-leftright-in-uitableviewcell/
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "Delete",
                                              handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                                                self.pack.members.remove(at: indexPath.item)
                                                self.users.remove(at: indexPath.item)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                                // Update persistence
                                                self.pack.writePack()
                                                success(true)
        })
        modifyAction.title = "Delete"
        modifyAction.backgroundColor = .red
        
        let result = UISwipeActionsConfiguration(actions: [modifyAction])
        result.performsFirstActionWithFullSwipe = false
        return result
    }
}
