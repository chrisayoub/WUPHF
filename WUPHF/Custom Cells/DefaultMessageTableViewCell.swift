//
//  DefaultMessageTableViewCell.swift
//  WUPHF
//
//  Created by Chris on 11/14/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class DefaultMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var textEntry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textEntry.delegate = KeyboardReturn.shared
    }

    func setText(text: String) {
        textEntry.text = text
    }
    
    func getText() -> String? {
        return textEntry.text
    }
}
