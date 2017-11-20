//
//  PackCollectionViewCell.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
    
    @IBAction func sendBark(_ sender: Any) {
    }
    @IBOutlet weak var packName: UILabel!
    @IBOutlet weak var packImage: UIButton!
    var delegate: PacksCollectionViewController!
    
    var members: [User] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func goToPack(_ sender: Any) {
        delegate.performSegue(withIdentifier: "ShowPack", sender: self)
    }
    func config(messageText: String, messageImage: UIImage, users: [User]) {
        packImage.layer.cornerRadius = packImage.frame.height/2
        packImage.layer.masksToBounds = true
        packName.text = messageText
        packImage.setBackgroundImage(messageImage, for: .normal)
        members = users
    }
}
