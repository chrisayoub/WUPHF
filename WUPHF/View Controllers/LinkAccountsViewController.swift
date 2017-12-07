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
    private var twitterLoginButton: TWTRLogInButton?
    
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
        // Logout
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        // Setup login button
        twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                // We are now logged into Twitter!
                
                // Hide button
                self.twitterLoginButton?.isHidden = true
                // Update user
                Common.loggedInUser?.twitterLinked = true;
                // Send to server
                APIHandler.shared.linkTwitter(id: Common.loggedInUser!.id,
                                              twId: (session?.userID)!,
                                              oauth: (session?.authToken)!,
                                              secret: (session?.authTokenSecret)!,
                                              completionHandler: nil)
            }
        })
        twitterLoginButton!.frame = twitterBtn.frame
        self.view.addSubview(twitterLoginButton!)
        
        if (Common.loggedInUser!.twitterLinked) {
            twitterLoginButton!.isHidden = true
        }
        
        // For the 8 plus
        if UIScreen.main.bounds.size.height == 736.0 {
            var fbCenter = facebookBtn.center
            fbCenter.x += 35
            facebookLoginButton!.center = fbCenter
            
            var twCenter = twitterBtn.center
            twCenter.x += 35
            twitterLoginButton!.center = twCenter
        }
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
        // Enable Twitter login button
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        twitterLoginButton!.isHidden = false
        // Unlink
        Common.loggedInUser!.twitterLinked = false
        // Send to server
        APIHandler.shared.unlinkTwitter(id: Common.loggedInUser!.id, completionHandler: nil)
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
