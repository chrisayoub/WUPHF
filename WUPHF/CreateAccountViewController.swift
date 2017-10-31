//
//  CreateAccountViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/29/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import Alamofire
import Security
import KeychainSwift

class CreateAccountViewController: RemoveKeyboardViewController {
    
    let keychain = KeychainSwift()
    
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var smsSwitch: UISwitch!
    
    @IBOutlet weak var passwordCheck: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set texfield delegates for keyboard removal in superclass
        fName.delegate = self
        lName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPass.delegate = self
        
        // hide password Check label on load
        passwordCheck.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountBtn(_ sender: Any) {
        guard let first = fName.text else {
            alertPopUp(warning: "Please enter your first name.")
            return
        }
        guard let last = lName.text else {
            alertPopUp(warning: "Please enter your last name.")
            return
        }
        guard let email = email.text else {
            alertPopUp(warning: "Please enter your email.")
            return
        }
        if(!isValidEmail(testStr: email)) {
            alertPopUp(warning: "Please enter a valid email.")
            return
        }
        guard let pass = password.text else {
            alertPopUp(warning: "Please enter a password.")
            return
        }
        guard let confPass = confirmPass.text else {
            alertPopUp(warning: "Please enter a password confirmation.")
            return
        }
        
        if (verifyPassword()) {
            // https://stackoverflow.com/questions/8090579/how-to-display-activity-indicator-in-middle-of-the-iphone-screen
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityView.center = self.view.center
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            // Check email not already used
            APIHandler.shared.getUserByEmail(email: email, completionHandler: { user in
                if user == nil {
                    // Save password
                    self.keychain.set(pass, forKey: email)
                    
                    // Post user to server, save mapping of email to ID
                    APIHandler.shared.createUser(firstName: first, lastName: last, email: email, completionHandler: { id in
                        var userIds = UserDefaults.standard.dictionary(forKey: "userIds")
                        if (userIds == nil) {
                            userIds = Dictionary()
                            UserDefaults.standard.set(userIds, forKey: "userIds")
                        }
                        userIds?["email"] = id
                        UserDefaults.standard.synchronize()
                    })
                    
                    // Make the segue
                    self.performSegue(withIdentifier: "accountCreated", sender: self)
                } else {
                    // User already exists
                    self.alertPopUp(warning: "User with given email already exists")
                }
                // Stop pinwheel
                activityView.stopAnimating()
            })
        } else {
            alertPopUp(warning: "Passwords do not match, please ensure your password matches your confirmation.")
        }
       
    }
   
    func verifyPassword() -> Bool{
        return (password.text!) == (confirmPass.text!)
    }
    /*func alertPopUp(warning: String){
        let alert = UIAlertController(title: "Error", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated: true, completion: nil)
        
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
