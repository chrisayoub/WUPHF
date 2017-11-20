//
//  CreateAccountViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/29/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import TwitterKit

class CreateAccountViewController: UIViewController, ModalViewControllerDelegate {
    
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var smsSwitch: UISwitch!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    var smsNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set texfield delegates for keyboard removal in superclass
        fName.delegate = KeyboardReturn.shared
        lName.delegate = KeyboardReturn.shared
        email.delegate = KeyboardReturn.shared
        password.delegate = KeyboardReturn.shared
        confirmPass.delegate = KeyboardReturn.shared
        
        // Facebook
        
        let fbLoginButton = LoginButton(readPermissions: [ .publicProfile ])
        fbLoginButton.frame = facebookButton.frame
        fbLoginButton.center = facebookButton.center
        fbLoginButton.sizeToFit()
       /* var frm = facebookButton.frame
        fbLoginButton.frame.origin.x = frm.origin.x
        fbLoginButton.frame.origin.y = frm.origin.y
        fbLoginButton.frame.size.width = frm.size.width
        fbLoginButton.frame.size. = frm.size.height */

      
        view.addSubview(fbLoginButton)
        
        // Twitter
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)")
                
                // Sign out
//
//                let store = Twitter.sharedInstance().sessionStore
//
//                if let userID = store.session()?.userID {
//                    store.logOutUserID(userID)
//                }
                
                
            } else {
                print("Error!")
            }
        })
        logInButton.frame = twitterButton.frame
        self.view.addSubview(logInButton)
    }
    
    @IBAction func createAccountBtn(_ sender: Any) {
        guard let first = fName.text else {
            Common.alertPopUp(warning: "Please enter your first name.", vc: self)
            return
        }
        guard let last = lName.text else {
            Common.alertPopUp(warning: "Please enter your last name.", vc: self)
            return
        }
        guard let email = email.text else {
            Common.alertPopUp(warning: "Please enter your email.", vc: self)
            return
        }
        if !Common.isValidEmail(testStr: email) {
            Common.alertPopUp(warning: "Please enter a valid email.", vc: self)
            return
        }
        guard let pass = password.text else {
            Common.alertPopUp(warning: "Please enter a password.", vc: self)
            return
        }
        guard let confPass = confirmPass.text else {
            Common.alertPopUp(warning: "Please enter a password confirmation.", vc: self)
            return
        }
        if pass == confPass {
            // https://stackoverflow.com/questions/8090579/how-to-display-activity-indicator-in-middle-of-the-iphone-screen
            let activityView = Common.getLoadingAnimation(view: self.view)
            activityView.startAnimating()
            
            // Check email not already used
            APIHandler.shared.getUserByEmail(email: email, completionHandler: { user in
                if user == nil {
                    // Save password
                    Common.keychain.set(pass, forKey: email)
                    
                    // Post user to server, save mapping of email to ID
                    APIHandler.shared.createUser(firstName: first, lastName: last, email: email, completionHandler: { id in
                        guard id != nil else {
                            Common.alertPopUp(warning: "Cannot create user on server.", vc: self)
                            return
                        }
                        
                        var userIds = UserDefaults.standard.dictionary(forKey: "userIds")
                        if userIds == nil {
                            userIds = Dictionary()
                            UserDefaults.standard.set(userIds, forKey: "userIds")
                        }
                        userIds?[email] = id
                        UserDefaults.standard.synchronize()
                        
                        // Get user from server
                        APIHandler.shared.getUser(id: id!, completionHandler: { user in
                            guard user != nil else {
                                Common.alertPopUp(warning: "Cannot get user from server.", vc: self)
                                return
                            }
                            
                            Common.loggedInUser = user
                            
                            // Add SMS to user if present
                            if let phoneNumber = self.smsNumber {
                                APIHandler.shared.linkSms(id: id!, number: phoneNumber, completionHandler: nil)
                            }
                            
                            // Add FB to user if present
                            
                            // Add TW to user if present
                            
                            // Make the segue
                            self.accountCreated(pinwheel: activityView)
                        })
                    })
                } else {
                    // User already exists
                    Common.alertPopUp(warning: "User with given email already exists", vc: self)
                }
            })
        } else {
            Common.alertPopUp(warning: "Passwords do not match, please ensure your password matches your confirmation.", vc: self)
        }
    }
    
    // Segues past account creation, stopping the activity indicator
    fileprivate func accountCreated(pinwheel: UIActivityIndicatorView?) {
        pinwheel?.stopAnimating()
        self.performSegue(withIdentifier: "accountCreated", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func smsSwitchToggled(_ sender: Any, forEvent event: UIEvent) {
        if smsSwitch.isOn {
            // Link SMS
            self.performSegue(withIdentifier: "verifySms", sender: self)
        } else {
            // Unlink SMS
            smsNumber = nil
        }
    }
    
    @IBAction func unlinkFacebook(_ sender: Any) {
    }
    
    @IBAction func unlinkTwitter(_ sender: Any) {
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "verifySms" {
            let destVC = segue.destination as! VerifySMSViewController
            destVC.smsSwitch = smsSwitch
            destVC.delegate = self
        }
    }
    
    // Gets value from SMS verify screen
    func sendValue(value: String?) {
        smsNumber = value
    }
}
