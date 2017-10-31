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

    let keychain = KeychainSwift()
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBAction func saveBtn(_ sender: Any) {
            guard let first = fName.text else{
                Common.alertPopUp(warning: "No First Name entered.", vc: self)
                return
            }
            guard let last = lName.text else{
                //passwordCheck.text = "No Last Name"
                Common.alertPopUp(warning: "No First Name entered.", vc: self)
                return
            }
            guard let email = email.text else{
                // passwordCheck.text = "No Email"
                Common.alertPopUp(warning: "No First Name entered.", vc: self)
                return
            }
            if !Common.isValidEmail(testStr: email) {
                //passwordCheck.text = "Invalid Email"
                Common.alertPopUp(warning: "No First Name entered.", vc: self)
                return
            }
            guard let pass = pass.text else{
                //passwordCheck.text = "No Password"
                Common.alertPopUp(warning: "No Password.", vc: self)
                return
            }
            guard let confPass = confirmPass.text else{
                //passwordCheck.text = "No Password to confirm"
                Common.alertPopUp(warning: "No Password to confirm", vc: self)
                return
            }
            
            if(verifyPassword()){
                keychain.set(pass, forKey: email)
                //post user to server
                self.performSegue(withIdentifier: "accountCreated", sender: self)
                
            } else {
                print("passFailed")
                //passwordCheck.text = "Passwords did not match"
                Common.alertPopUp(warning: "Passwords did not match", vc: self)
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
        fName.delegate = KeyboardReturn.shared
        lName.delegate = KeyboardReturn.shared
        email.delegate = KeyboardReturn.shared
        pass.delegate = KeyboardReturn.shared
        confirmPass.delegate = KeyboardReturn.shared
        
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
