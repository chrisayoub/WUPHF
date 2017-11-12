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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var requested: UILabel!
    
    private var user: User?
    private var parent: UIViewController?
    
    override func awakeFromNib() {
        requested.isHidden = true
    }
    
    func setInfo(user: User, parent: UIViewController) {
        self.user = user
        self.parent = parent
        fullName.text = "\(user.firstName) \(user.lastName)"
        email.text = user.email
        if user.requested {
            setRequested()
        }
    }
    
    func setRequested() {
        addButton.isHidden = true
        requested.isHidden = false
    }

    @IBAction func add(_ sender: Any) {
        setRequested()
    }
}

