//
//  LinkAccountsViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import TwitterKit

class LinkAccountsViewController: UIViewController, ModalViewControllerDelegate {

    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var switchSms: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLoginButton = LoginButton(readPermissions: [ .publicProfile ])
        fbLoginButton.frame = facebookBtn.frame
        view.addSubview(fbLoginButton)
       
        // Twitter
        twitterBtn.isUserInteractionEnabled = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let fbToken = AccessToken.current {
            print(fbToken.userId!)
            // fbToken.
           // Common.loggedInUser?.fbAccessToken = fbToken
        }
    }
    
    @IBAction func switchToggle(_ sender: Any) {
        if switchSms.isOn {
            // Link SMS
            self.performSegue(withIdentifier: "verifySmsSettings", sender: self)
        } else {
            // Unlink SMS
            APIHandler.shared.unlinkSms(id: Common.loggedInUser!.id, completionHandler: { success in
                let user = Common.loggedInUser!
                user.enableSMS = false
                user.phone = ""
            })
        }
    }
    
    // Gets value from SMS verify screen
    func sendValue(value: String?) {
        let user = Common.loggedInUser!
        APIHandler.shared.linkSms(id: user.id, number: value!, completionHandler: { success in
            user.enableSMS = true
            user.phone = value!
        })
    }
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "verifySmsSettings" {
             let destVC = segue.destination as! VerifySMSViewController
             destVC.smsSwitch = switchSms
             destVC.delegate = self
         }
     }

}
