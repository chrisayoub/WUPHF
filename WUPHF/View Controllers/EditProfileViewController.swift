//
//  EditProfileViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import KeychainSwift

class EditProfileViewController: CommonViewController {

    let keychain = KeychainSwift()
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBAction func saveBtn(_ sender: Any) {
            guard let first = fName.text else{
                //passwordCheck.text = "No First Name"
                alertPopUp(warning: "No First Name entered.")
                return
            }
            guard let last = lName.text else{
                //passwordCheck.text = "No Last Name"
                alertPopUp(warning: "No First Name entered.")
                return
            }
            guard let email = email.text else{
                // passwordCheck.text = "No Email"
                alertPopUp(warning: "No First Name entered.")
                return
            }
            if(!isValidEmail(testStr: email)){
                //passwordCheck.text = "Invalid Email"
                alertPopUp(warning: "No First Name entered.")
                return
            }
            guard let pass = pass.text else{
                //passwordCheck.text = "No Password"
                alertPopUp(warning: "No Password.")
                return
            }
            guard let confPass = confirmPass.text else{
                //passwordCheck.text = "No Password to confirm"
                alertPopUp(warning: "No Password to confirm")
                return
            }
            
            if(verifyPassword()){
                keychain.set(pass, forKey: email)
                //post user to server
                self.performSegue(withIdentifier: "accountCreated", sender: self)
                
            } else {
                print("passFailed")
                //passwordCheck.text = "Passwords did not match"
                alertPopUp(warning: "Passwords did not match")
            }
            
    }
        
    func verifyPassword() -> Bool{
        print("\(pass.text!) \(confirmPass.text!)")
        if((pass.text!) == (confirmPass.text!)){
            return true;
        }
        print("in failed pass")
        return false;
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate textfields with backend user values
        /*
         fName.text =
         lName.text =
         email.text =
         */
        
        // Set textfield delegates for RemoveKeyboardViewController
        fName.delegate = self
        lName.delegate = self
        email.delegate = self
        pass.delegate = self
        confirmPass.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
