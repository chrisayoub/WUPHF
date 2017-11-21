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
    var delegate: PacksCollectionViewController!
    
    @IBOutlet weak var packImage: UIImageView!
    var members: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func goToPack(_ sender: Any) {
        delegate.performSegue(withIdentifier: "ShowPack", sender: self)
    }
    func config(messageText: String, messageImage: UIImage, users: [Int]) {
       // packImage.layer.cornerRadius = packImage.frame.height/2
        //packImage.layer.masksToBounds = true
        packName.text = messageText
        packName.bringSubview(toFront: self)
        packImage.image=messageImage
        members = users
    }
}
