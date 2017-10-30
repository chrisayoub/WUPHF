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

class CreateAccountViewController: UIViewController {
    
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
        passwordCheck.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountBtn(_ sender: Any) {
        
        guard let first = fName.text else{
            passwordCheck.text = "No First Name"
            return
        }
        guard let last = lName.text else{
            passwordCheck.text = "No Last Name"
            return
        }
        guard let email = email.text else{
            passwordCheck.text = "No Email"
            return
        }
        guard let pass = password.text else{
            passwordCheck.text = "No Password"
            return
        }
        guard let confPass = confirmPass.text else{
            passwordCheck.text = "No Password to confirm"
            return
        }
        
        if(verifyPassword()){
            keychain.set(pass, forKey: email)
            //post user to server
            self.performSegue(withIdentifier: "accountCreated", sender: self)

        } else {
            print("passFailed")
            passwordCheck.text = "Passwords did not match"
        }
       
    }
    func verifyPassword() -> Bool{
        print("\(password.text!) \(confirmPass.text!)")
        if((password.text!) == (confirmPass.text!)){
            return true;
        }
        print("in failed pass")
        return false;
        
        
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
