//
//  SendWUPHFViewController.swift
//  WUPHF
//
//  Created by Chris on 11/16/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class SendWUPHFViewController: UIViewController, UITableViewDataSource {
    
    private var messages: [String] = []
    
    var target: User?

    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        
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

        // Do any additional setup after loading the view.
        
    }

    @IBAction func sendBtn(_ sender: Any) {
        print(target)
        APIHandler.shared.sendWUPHF(userId: Common.loggedInUser!.id,
            friendId: target!.id, message: txtField.text) { (success) in
                if success {
                    Common.alertPopUp(warning: "WUPHF Succesfull!", vc: self, completion: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    Common.alertPopUp(warning: "WUPHF Failed!", vc: self, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
