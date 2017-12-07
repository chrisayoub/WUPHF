//
//  DefaultMessagesTableViewController.swift
//  WUPHF
//
//  Created by Chris on 11/14/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class DefaultMessagesTableViewController: UITableViewController {

    var messages: [String] = []
    var cells: [DefaultMessageTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var messages = UserDefaults.standard.dictionary(forKey: "defaultMessages")
        if messages == nil {
            messages = Dictionary()
            UserDefaults.standard.set(messages, forKey: "defaultMessages")
        }
        if let msgList = messages![String(describing: Common.loggedInUser!.id)] {
            self.messages = msgList as! [String]
        }
        UserDefaults.standard.synchronize()
        
        self.tableView.rowHeight = 48.0;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    @IBAction func newRow(_ sender: Any) {
        messages.append("")
        tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultMessage", for: indexPath) as! DefaultMessageTableViewCell
        cell.setText(text: messages[indexPath.item])
        cell.selectionStyle = .none
        cells.append(cell)
        return cell
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            var messages = UserDefaults.standard.dictionary(forKey: "defaultMessages")
            var newMessages: [String] = []
            for cell in cells {
                if let msg = cell.getText(), !msg.isEmpty {
                    newMessages.append(msg)
                }
            }
            messages![String(describing: Common.loggedInUser!.id)] = newMessages
            UserDefaults.standard.set(messages, forKey: "defaultMessages")
            UserDefaults.standard.synchronize()
        }
    }
}
