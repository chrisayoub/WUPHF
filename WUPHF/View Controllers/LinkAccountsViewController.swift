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
        fbLoginButton.frame = facebookBtn.frame
        view.addSubview(fbLoginButton)
       // fbLoginButton.addConstraints(facebookBtn.constraints)
        //view.addSubview(fbLoginButton)
       
        // Twitter
        twitterBtn.isUserInteractionEnabled = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let fbToken = AccessToken.current {
            print(fbToken.userId!)
            APIHandler.shared.linkFacebook(id: (Common.loggedInUser?.id)!, fbId: fbToken.userId!, token: fbToken.authenticationToken, completionHandler: {user in  guard user != nil else {
                    Common.alertPopUp(warning: "Cannot send to server.", vc: self)
                    return
                }
                
                Common.loggedInUser?.facebookLinked = true;
            })
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
