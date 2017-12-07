//
//  EditProfileViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import KeychainSwift

class EditProfileViewController: UIViewController {

    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate textfields with backend user values
        fName.text = Common.loggedInUser?.firstName
        lName.text = Common.loggedInUser?.lastName
        email.text = Common.loggedInUser?.email
 
        // Set textfield delegates for RemoveKeyboardViewController
        fName.delegate = KeyboardReturn.shared
        lName.delegate = KeyboardReturn.shared
        email.delegate = KeyboardReturn.shared
        pass.delegate = KeyboardReturn.shared
        confirmPass.delegate = KeyboardReturn.shared
    }
    
    @IBAction func saveBtn(_ sender: Any) {
            guard let first = fName.text else{
                Common.alertPopUp(warning: "Please enter your first name.", vc: self)
                return
            }
        
            guard let last = lName.text else{
                Common.alertPopUp(warning: "Please enter your last name.", vc: self)
                return
            }
        
            guard let email = email.text else{
                Common.alertPopUp(warning: "Please enter your email.", vc: self)
                return
            }
        
            if !Common.isValidEmail(testStr: email) {
                Common.alertPopUp(warning: "Please enter a valid email.", vc: self)
                return
            }
        
            guard let pass = pass.text, pass != "" else {
                Common.alertPopUp(warning: "Please enter a password.", vc: self)
                return
            }
        
            guard let confPass = confirmPass.text, confPass != "" else {
                Common.alertPopUp(warning: "Please enter a password confirmation.", vc: self)
                return
            }
            
            if pass == confPass {
                // Update password locally
                Common.keychain.set(pass, forKey: email)
                
                // Update logged-in user
                let user = Common.loggedInUser!
                user.firstName = first
                user.lastName = last
                user.email = email
                
                // Post update to server
                APIHandler.shared.updateUser(id: user.id, firstName: user.firstName, lastName: user.lastName, email: user.email, completionHandler: nil)
                
                // Update email to ID mapping
                var userIds = UserDefaults.standard.dictionary(forKey: "userIds")
                let currentEmail = user.email
                let id = user.id
                userIds?.removeValue(forKey: currentEmail)
                userIds?[email] = id
                UserDefaults.standard.synchronize()
                
                // Tell user it worked
                Common.alertPopUp(warning: "Your profile has been updated.", vc: self, completion: { alert in
                    // Go back
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                Common.alertPopUp(warning: "Passwords do not match.", vc: self)
            }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
