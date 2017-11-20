//
//  PackMembersTableViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackMembersTableViewController: UITableViewController {
    
    var alert:UIAlertController? = nil
    var pack: Pack!
    var members: [User] = []
    var email: UITextField!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = pack.name
        members = pack.members
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //TODO: Change to packs
        /*APIHandler.shared.getFriends(id: Common.loggedInUser!.id) { (users) in
            self.members =
            self.tableView.reloadData()
        }*/
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! PackMembersTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.sendInfo(user: members[indexPath.item])
        return cell
    }
    
    @IBAction func addContact(_ Sender: AnyObject) {
        self.alert = UIAlertController(title: "Add Member", message: "", preferredStyle: UIAlertControllerStyle.alert)
        self.alert!.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.default))
        
        
        
        
        alert?.addTextField(configurationHandler: { (textField : UITextField) -> Void in
            self.email = textField
        })
        var mail: String = ""
        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (sender : UIAlertAction) -> Void in
            mail = (self.email?.text!)!
            print("writing name")
            self.members.append(User(id: 5, firstName: "JAY", lastName: "bay", email: mail, phone: "23", enableSMS: false, facebookLinked: false, twitterLinked: false))
            //add pack to DB
            
        })
        
        self.alert?.addAction(doneAction)
        
        self.present(self.alert!, animated: true, completion: nil)
    }
    
    // https://developerslogblog.wordpress.com/2017/06/28/ios-11-swipe-leftright-in-uitableviewcell/
    /*override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.item == 0 {
            return UISwipeActionsConfiguration(actions: [])
        }
        //TODO: customize for actions
        /*let modifyAction = UIContextualAction(style: .normal, title: "Delete",
                                              handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                                                let friend = self.members.remove(at: indexPath.item - 1)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                                // Delete from server
                                                //TODO: Remove from pack not delete friend
                                                //APIHandler.shared.deleteFriend(userId: Common.loggedInUser!.id, friendId: friend.id, completionHandler: nil)
                                                success(true)
        })*/
      //  modifyAction.title = "Delete"
        //modifyAction.backgroundColor = .red
        
      //  let result = UISwipeActionsConfiguration(actions: [modifyAction])
        result.performsFirstActionWithFullSwipe = false
        return result
    }*/

}
