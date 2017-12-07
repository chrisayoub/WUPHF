//
//  PackCollectionViewCell.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var packName: UILabel!
    @IBOutlet weak var packImage: UIImageView!
    
    var pack: Pack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        packName.text = ""
    }

    func config(pack: Pack, messageImage: UIImage) {
        packName.text = pack.name
        packName.bringSubview(toFront: self)
        packImage.image = messageImage
    }
}
