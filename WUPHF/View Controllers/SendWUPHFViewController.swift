//
//  SendWUPHFViewController.swift
//  WUPHF
//
//  Created by Chris on 11/16/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class SendWUPHFViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var messages: [String] = []
    private var wuphfInProgess = false
    
    var targetIds: [Int] = []

    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.layer.cornerRadius = 15.0
        txtField.layer.cornerRadius = 15.0
        
        var messages = UserDefaults.standard.dictionary(forKey: "defaultMessages")
        if messages == nil {
            messages = Dictionary()
            UserDefaults.standard.set(messages, forKey: "defaultMessages")
        }
        if let msgList = messages![String(describing: Common.loggedInUser!.id)] {
            self.messages = msgList as! [String]
            table.reloadData()
            if(self.messages.count > 0){
                txtField.text = self.messages[0]
            } else {
                txtField.text = ""
            }
        }
        UserDefaults.standard.synchronize()
    }

    @IBAction func sendBtn(_ sender: Any) {
        if wuphfInProgess {
            return
        }
        self.wuphfInProgess = true

        var totalSuccess = true
        for i in 0 ..< targetIds.count {
            APIHandler.shared.sendWUPHF(userId: Common.loggedInUser!.id,
                                        friendId: targetIds[i],
                                        message: txtField.text)
            { (success) in
                if !success {
                    totalSuccess = false
                }
                // Display message on last iteration
                if i == self.targetIds.count - 1 {
                    // Get action from navigation item title
                    let action = (self.navigationItem.title?.split(separator: " ")[1])!
                    if totalSuccess {
                        Common.alertPopUp(warning: "\(action) successful!", vc: self, completion: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        Common.alertPopUp(warning: "\(action) failed!", vc: self, completion: nil)
                    }
                    self.wuphfInProgess = false
                }
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayMessage", for: indexPath)
        cell.textLabel?.text = messages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtField.text = messages[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
