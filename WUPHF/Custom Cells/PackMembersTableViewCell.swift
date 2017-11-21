//
//  PackMembersTableViewCellController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackMembersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var member: UILabel!
    var delegate: PackMembersTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        member.text = ""
        
    }
    
    func sendInfo(user: User) {
        
        member.text = "\(user.firstName) \(user.lastName)"
    }
    @IBAction func sendWuphf(_ sender: Any) {
        delegate.performSegue(withIdentifier: "SendWuphf", sender: self)
    }
}
