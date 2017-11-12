//
//  AddContactViewController.swift
//  WUPHF
//
//  Created by Chris on 11/11/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        table.dataSource = self
        table.delegate = self
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
        cell.setInfo(user: users[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIHandler.shared.searchUsers(query: searchText) { users in
            self.users = users
            self.table.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
