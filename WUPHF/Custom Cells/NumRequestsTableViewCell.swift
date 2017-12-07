//
//  NumRequestsTableViewCell.swift
//  WUPHF
//
//  Created by Chris on 12/7/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class NumRequestsTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let label = self.accessoryView as? UILabel {
            label.backgroundColor = .red
        }
    }
}
