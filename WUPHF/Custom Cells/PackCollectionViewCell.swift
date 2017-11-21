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
    
    var members: [Int] = []
    var parentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(messageText: String, messageImage: UIImage, users: [Int]) {
        // packImage.layer.cornerRadius = packImage.frame.height/2
        // packImage.layer.masksToBounds = true
        packName.text = messageText
        packName.bringSubview(toFront: self)
        packImage.image = messageImage
        members = users
    }
    
    @IBAction func sendBark(_ sender: Any) {
        let us = Common.loggedInUser!.id
        
        let alertController = UIAlertController(title: "Enter your message", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        var textEntry: UITextField?
        alertController.addTextField(configurationHandler: { (textField : UITextField) -> Void in
            textEntry = textField
        })
        
        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (sender : UIAlertAction) -> Void in
            if let text = textEntry!.text {
                for id in self.members {
                    APIHandler.shared.sendWUPHF(userId: us, friendId: id,
                                                message: text,
                                                completionHandler: nil)
                }
            }
            Common.alertPopUp(warning: "Bark successful!", vc: self.parentVC!)
        })
        
        alertController.addAction(doneAction)
        parentVC!.present(alertController, animated: true, completion: nil)
    }
}
