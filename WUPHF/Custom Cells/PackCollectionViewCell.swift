//
//  PackCollectionViewCell.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell, SetPackMembers {
    
    @IBOutlet weak var packName: UILabel!
    @IBOutlet weak var packImage: UIImageView!
    
    var members: [Int] = []
    var parentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(messageText: String, messageImage: UIImage, users: [Int]) {
        packName.text = messageText
        packName.bringSubview(toFront: self)
        packImage.image = messageImage
        members = users
    }
    
    func setPackMembers(members: [Int]) {
        self.members = members
    }
}
