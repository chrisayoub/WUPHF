//
//  SettingsViewController.swift
//  WUPHF
//
//  Created by Chris on 10/31/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
            Common.loggedInUser = nil
            let vc = self.parent!.parent as! UITabBarController
            vc.tabBar.isHidden = true
        }
    }
}
