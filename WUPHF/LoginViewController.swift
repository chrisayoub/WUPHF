//
//  LoginViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/29/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: RemoveKeyboardViewController {

    let keychain = KeychainSwift()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginCheck: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        loginCheck.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginBrn(_ sender: Any) {
       
        guard let mail = email.text else{
            //loginCheck.text = "No Email"
            alertPopUp(warning: "Login Failed.")
            return
        }
        guard let pass = password.text else{
            //loginCheck.text = "No Password"
            alertPopUp(warning: "Login Failed.")
            return
        }
               guard let keyPass:String = keychain.get(mail) else{
            //loginCheck.text = "Login Failed"
                alertPopUp(warning: "Login Failed.")
            return
        }
        if(keyPass == pass){
            self.performSegue(withIdentifier: "login", sender: self)
        } else {
            //loginCheck.text = "Login Failed"
            alertPopUp(warning: "Login Failed.")
        }
        
        
        
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
