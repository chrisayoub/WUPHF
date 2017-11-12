//
//  AddContactTableViewCell.swift
//  WUPHF
//
//  Created by Chris on 11/12/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddContactTableViewCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    private var user: User?
    
    func setInfo(user: User) {
        self.user = user
        fullName.text = "\(user.firstName) \(user.lastName)"
        email.text = user.email
    }

    @IBAction func add(_ sender: Any) {
        print("Pressed!")
    }
}
