//
//  AddToPackTableViewCell.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/20/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddToPackTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    private var user: User?
    private var delegate: AddUserToPack?
    private var pack: Pack?

    func sendInfo(user: User, pack: Pack, delegate: AddUserToPack) {
        self.user = user
        self.pack = pack
        self.delegate = delegate
        name.text = "\(user.firstName) \(user.lastName)"
    }
    
    @IBAction func addBtn(_ sender: Any) {
        delegate!.addUserToPack(user: user!, pack: pack!)
    }
}

protocol AddUserToPack {
    func addUserToPack(user: User, pack: Pack)
}
