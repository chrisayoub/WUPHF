//
//  LoginViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/29/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = KeyboardReturn.shared
        password.delegate = KeyboardReturn.shared
        
        if getAuthString() == nil {
            // Unlink account if no local auth
            Common.setLocalAuthAccountId(id: nil)
        } else if let id = Common.getLocalAuthAccountId() {
            // Local auth available, and linked!
            APIHandler.shared.getUser(id: id, completionHandler: { (user) in
                // Get user from server before auth
                if user != nil {
                    self.email.text = user!.email
                    self.doLocalAuth(user: user!)
                }
            })
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let mail = email.text, mail != "" else {
            Common.alertPopUp(warning: "Please enter your email.", vc: self)
            return
        }
        
        guard Common.isValidEmail(testStr: mail) else {
            Common.alertPopUp(warning: "Please enter a valid email.", vc: self)
            return
        }
        
        guard let pass = password.text, pass != "" else {
            Common.alertPopUp(warning: "Please enter your password.", vc: self)
            return
        }
        
        guard let keyPass: String = Common.keychain.get(mail) else {
            Common.alertPopUp(warning: "Account does not exist.", vc: self)
            return
        }
        
        if keyPass != pass {
            Common.alertPopUp(warning: "Password does not match.", vc: self)
            return
        }
        
        let loading = Common.getLoadingAnimation(view: self.view)
        loading.startAnimating()
        APIHandler.shared.getUserByEmail(email: mail, completionHandler: { user in
            if user == nil {
                Common.alertPopUp(warning: "Account does not exist on server.", vc: self)
            } else {
                // Save the user
                Common.loggedInUser = user
                
                // Check for Local Auth
                guard let authStr = self.getAuthString() else {
                    self.doSegue()
                    return
                }

                // Check if we already have Touch ID linked for an account
                // This is where the linked user is logging in via password
                if Common.getLocalAuthAccountId() == user!.id {
                    self.doSegue()
                    return
                }
                
                // Ask to save Touch ID for the current, different user
                let message = "Login successful! Do you want to save this account with " + authStr + "?"
                let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    // Save the account as linked to Touch ID
                    Common.setLocalAuthAccountId(id: user!.id)
                    self.doSegue()
                }))

                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                    self.doSegue()
                }))

                self.present(alert, animated: true, completion: nil)
            }
            loading.stopAnimating()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doSegue() {
        // Go to next screen
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    // MARK: Local auth functions
    
    func doLocalAuth(user: User) {
        let context = LAContext()
        let myLocalizedReasonString = "Login with \(user.email)"
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: myLocalizedReasonString)
            { success, evaluateError in
                if success {
                    // User authenticated successfully, get info from server
                    Common.loggedInUser = user
                    self.doSegue()
                }
                // Ignore failure to login, can retry on own
            }
        } else {
            // Clear saved account ID, if any
            Common.setLocalAuthAccountId(id: nil)
        }
    }
    
    func getAuthString() -> String? {
        let context = LAContext()
        var result: String?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let type = context.biometryType
            if type == .typeFaceID {
                result = "Face ID"
            } else if type == .typeTouchID {
                result = "Touch ID"
            }
        }
        context.invalidate()
        return result
    }
}
