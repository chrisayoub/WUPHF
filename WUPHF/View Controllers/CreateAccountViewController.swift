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
    
    private var facebookLoginButton: LoginButton?
    private var fbAccessToken: AccessToken?
    
    private var twitterLoginButton: TWTRLogInButton?
    private var twitterSession: TWTRSession?
    
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
        LoginManager().logOut()
        facebookLoginButton = LoginButton(publishPermissions: [ .publishActions ])
        facebookLoginButton!.frame = facebookButton.frame
        view.addSubview(facebookLoginButton!)
        
        // Twitter
        // Sign out
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        // Create button
        twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
            if let login = session {
                // We are now logged into Twitter!
                self.twitterSession = login
                self.twitterLoginButton!.isHidden = true
            }
        })
        twitterLoginButton!.frame = twitterButton.frame
        self.view.addSubview(twitterLoginButton!)
        
        // For the 8 plus
        if UIScreen.main.bounds.size.height == 736.0 {
            var fbCenter = facebookButton.center
            fbCenter.x += 35
            facebookLoginButton!.center = fbCenter
            
            var twCenter = twitterButton.center
            twCenter.x += 35
            twitterLoginButton!.center = twCenter
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let fbToken = AccessToken.current {
            // We are now logged into Facebook!
            
            // Save token
            fbAccessToken = fbToken
            // Hide button
            facebookLoginButton!.isHidden = true
        }
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
                            
                            // Add SMS to user if present
                            if let phoneNumber = self.smsNumber {
                                APIHandler.shared.linkSms(id: id!, number: phoneNumber, completionHandler: nil)
                                user!.enableSMS = true
                            }
                            
                            // Add FB to user if present
                            if let fbToken = self.fbAccessToken {
                                APIHandler.shared.linkFacebook(id: id!,
                                                               fbId: fbToken.userId!,
                                                               token: fbToken.authenticationToken,
                                                               completionHandler: nil)
                                user!.facebookLinked = true
                            }
                            LoginManager().logOut()
                            
                            // Add TW to user if present
                            if let twSession = self.twitterSession {
                                APIHandler.shared.linkTwitter(id: id!,
                                                              twId: twSession.userID,
                                                              oauth: twSession.authToken,
                                                              secret: twSession.authTokenSecret,
                                                              completionHandler: nil)
                                user!.twitterLinked = true
                            }
                            let store = Twitter.sharedInstance().sessionStore
                            if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
                                store.logOutUserID(userID)
                            }
                            
                            // Set the user
                            Common.loggedInUser = user
                            
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
        LoginManager().logOut()
        facebookLoginButton!.isHidden = false
        fbAccessToken = nil
    }
    
    @IBAction func unlinkTwitter(_ sender: Any) {
        // Log out
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        // Enable button
        twitterLoginButton!.isHidden = false
        // Clear session
        twitterSession = nil
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
