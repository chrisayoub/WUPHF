//
//  ContactTableViewCell.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    private var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
    }
    
    func sendInfo(user: User) {
        self.user = user
        name.text = "\(user.firstName) \(user.lastName)"
    }
    
    @IBAction func sendWuphf(_ sender: Any) {
        print ("TODO!")
    }
}
