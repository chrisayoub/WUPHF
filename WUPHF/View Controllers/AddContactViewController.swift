//
//  AddContactViewController.swift
//  WUPHF
//
//  Created by Chris on 11/11/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        table.dataSource = self
        self.table.rowHeight = 62.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addContact", for: indexPath) as! AddContactTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.setInfo(user: users[indexPath.item], parent: self)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIHandler.shared.searchUsers(id: Common.loggedInUser!.id, query: searchText) { users in
            self.users = users
            self.table.reloadData()
        }
    }
}
