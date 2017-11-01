//
//  LinkAccountsViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import TwitterKit

class LinkAccountsViewController: UIViewController {

    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLoginButton = LoginButton(readPermissions: [ .publicProfile ])
        //loginButton.center = CGPointMake(facebookBtn.frame.midX, facebookBtn.frame.midY)
        fbLoginButton.frame = facebookBtn.frame
        view.addSubview(fbLoginButton)
       // Do any additional setup after loading the view.
        //Twitter
        let tLoginButton = TWTRLogInButton { (session, error) in
            guard let unwrappedSession = session else {//early return if error
                print("Login error: %@", error!.localizedDescription);
                return
            }
        }
        tLoginButton.frame = twitterBtn.frame
        self.view.addSubview(tLoginButton)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let fbToken = AccessToken.current{
            print(fbToken.userId!)
           // Common.loggedInUser?.fbAccessToken = fbToken
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
