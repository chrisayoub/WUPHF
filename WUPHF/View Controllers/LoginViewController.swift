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
    }
    
    @IBAction func loginBtn(_ sender: Any) {
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
        
        if (keyPass != pass) {
            Common.alertPopUp(warning: "Password does not match.", vc: self)
            return
        }
        
        let loading = Common.getLoadingAnimation(view: self.view)
        loading.startAnimating()
        APIHandler.shared.getUserByEmail(email: mail, completionHandler: { user in
            if user == nil {
                Common.alertPopUp(warning: "Account does not exist.", vc: self)
            } else {
                // Save the user
                Common.loggedInUser = user
                
                // Ask to save Touch ID
//                let loginStr = LAContext().biometryType == .typeTouchID ? "Touch ID" : "Face ID"
//                let message = "Login success! Do you want to enable " + loginStr + " for this account?"
//                let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
//
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//                    // Go to next screen
//                    self.performSegue(withIdentifier: "login", sender: self)
//                }))
//
//                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
//                    // Go to next screen
//                    self.performSegue(withIdentifier: "login", sender: self)
//                }))
//
//                self.present(alert, animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "login", sender: self)
            }
            loading.stopAnimating()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
