//
//  PendingRequestTableViewCell.swift
//  WUPHF
//
//  Created by Chris on 11/13/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PendingRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    private var user: User?
    private var modifyRequest: ModifyRequestDelegate?
    private var requestIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
    }

    func setInfo(user: User, modify: ModifyRequestDelegate, requestIndex: IndexPath) {
        self.modifyRequest = modify
        self.requestIndex = requestIndex
        self.user = user
        name.text = "\(user.firstName) \(user.lastName)"
    }

    @IBAction func accept(_ sender: Any) {
        modifyRequest?.acceptUser(requestIndex: requestIndex!)
    }
    
    @IBAction func decline(_ sender: Any) {
        modifyRequest?.declineUser(requestIndex: requestIndex!)
    }
}

protocol ModifyRequestDelegate {
    func acceptUser(requestIndex: IndexPath)
    func declineUser(requestIndex: IndexPath)
}
