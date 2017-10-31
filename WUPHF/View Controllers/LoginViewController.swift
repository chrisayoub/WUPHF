//
//  LoginViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/29/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class LoginViewController: CommonVC {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let mail = email.text, mail != "" else {
            alertPopUp(warning: "Please enter your email.")
            return
        }
        
        guard isValidEmail(testStr: mail) else {
            alertPopUp(warning: "Please enter a valid email.")
            return
        }
        
        guard let pass = password.text, pass != "" else {
            alertPopUp(warning: "Please enter your password.")
            return
        }
        
        guard let keyPass: String = CommonVC.keychain.get(mail) else {
            alertPopUp(warning: "Account does not exist.")
            return
        }
        
        if (keyPass != pass) {
            alertPopUp(warning: "Password does not match.")
            return
        }
        
        let loading = getLoadingAnimation()
        loading.startAnimating()
        APIHandler.shared.getUserByEmail(email: mail, completionHandler: { user in
            if user == nil {
                self.alertPopUp(warning: "Account does not exist.")
            } else {
                // Save the user
                CommonVC.loggedInUser = user
                // Go to next screen
                self.performSegue(withIdentifier: "login", sender: self)
            }
            loading.stopAnimating()
        })
    }
}
