//
//  RemoveKeyboardViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import KeychainSwift
import Security

class Common {
    
    static let keychain = KeychainSwift()
    static var loggedInUser: User?

    static func alertPopUp(warning: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert,animated: true, completion: nil)
    }
    
    // Credit to https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func getLoadingAnimation(view: UIView) -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
        return activityView
    }
    
    static func isValidPhone(testStr: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: testStr)
        return result
    }
}
