//
//  PendingRequestsTableViewController.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PendingRequestsTableViewController: UITableViewController, ModifyRequestDelegate {

    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loading = Common.getLoadingAnimation(view: self.view)
        loading.startAnimating()
        APIHandler.shared.getFriendRequests(id: Common.loggedInUser!.id) { (users) in
            self.users = users
            self.tableView.reloadData()
            loading.stopAnimating()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingRequest", for: indexPath) as! PendingRequestTableViewCell
        cell.setInfo(user: users[indexPath.item], modify: self, requestIndex: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func acceptUser(requestIndex: IndexPath) {
        let user = users.remove(at: requestIndex.item)
        self.tableView.deleteRows(at: [requestIndex], with: .automatic)
        APIHandler.shared.acceptFriendRequest(requester: user.id, reciever: Common.loggedInUser!.id, completionHandler: nil)
    }
    
    func declineUser(requestIndex: IndexPath) {
        let user = users.remove(at: requestIndex.item)
        self.tableView.deleteRows(at: [requestIndex], with: .automatic)
        APIHandler.shared.declineFriendRequest(requester: user.id, reciever: Common.loggedInUser!.id, completionHandler: nil)
    }
}
