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
    
    private var facebookLoginButton: LoginButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SMS
        switchSms.setOn(Common.loggedInUser!.enableSMS, animated: false)
        
        // Facebook
        LoginManager().logOut()
        facebookLoginButton = LoginButton(publishPermissions: [ .publishActions ])
        facebookLoginButton!.frame = facebookBtn.frame
        view.addSubview(facebookLoginButton!)
        
        if (Common.loggedInUser!.facebookLinked) {
            facebookLoginButton!.isHidden = true
        }
        
        // Twitter
//        let twLogInButton = TWTRLogInButton(logInCompletion: { session, error in
//            if (session != nil) {
//                print("signed in as \(session!.userName)")
//
//                // Sign out
//                //
//                //                let store = Twitter.sharedInstance().sessionStore
//                //
//                //                if let userID = store.session()?.userID {
//                //                    store.logOutUserID(userID)
//                //                }
//
//
//            } else {
//                print("Error!")
//            }
//        })
//        twLogInButton.frame = twitterBtn.frame
//        self.view.addSubview(twLogInButton)
        twitterBtn.isHidden = true
        
        // For the 8 plus
        if UIScreen.main.bounds.size.height == 736.0 {
            var fbCenter = facebookBtn.center
            fbCenter.x += 35
            facebookLoginButton!.center = fbCenter
            
//            var twCenter = twitterBtn.center
//            twCenter.x += 37
//            twLogInButton.center = twCenter
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let fbToken = AccessToken.current {
            // We are now logged into Facebook!
            
            // Hide button
            facebookLoginButton!.isHidden = true
            // Update user
            Common.loggedInUser?.facebookLinked = true;
            // Send to server
            APIHandler.shared.linkFacebook(id: (Common.loggedInUser?.id)!,
                                           fbId: fbToken.userId!,
                                           token: fbToken.authenticationToken,
                                           completionHandler: nil)
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
    
    @IBAction func unlinkFacebook(_ sender: Any) {
        // Enable Facebook login button
        LoginManager().logOut()
        facebookLoginButton!.isHidden = false
        // Unlink
        Common.loggedInUser!.facebookLinked = false
        // Send to server
        APIHandler.shared.unlinkFacebook(id: Common.loggedInUser!.id, completionHandler: nil)
    }
    
    @IBAction func unlinkTwitter(_ sender: Any) {
        
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
