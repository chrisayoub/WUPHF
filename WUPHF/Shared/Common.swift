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
import LocalAuthentication

class Common {
    
    static let keychain = KeychainSwift()
    static var loggedInUser: User?

    static func alertPopUp(warning: String, vc: UIViewController) {
        Common.alertPopUp(warning: warning, vc: vc, completion: nil)
    }
    
    static func alertPopUp(warning: String, vc: UIViewController, completion: ((_ : UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: warning, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completion))
        vc.present(alert, animated: true, completion: nil)
    }
    
    // Credit to https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func getLoadingAnimation(view: UIView) -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = .black
        activityView.center = view.center
        view.addSubview(activityView)
        return activityView
    }
    
    static func isValidPhone(testStr: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let PHONE_ALT_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let phoneAltTest = NSPredicate(format: "SELF MATCHES %@", PHONE_ALT_REGEX)
        let result = phoneTest.evaluate(with: testStr) || phoneAltTest.evaluate(with: testStr)
        return result
    }
    
    static func getDefaultMessages() -> [String] {
        var messages = UserDefaults.standard.dictionary(forKey: "defaultMessages")
        if messages == nil {
            messages = Dictionary()
            UserDefaults.standard.set(messages, forKey: "defaultMessages")
            UserDefaults.standard.synchronize()
        }
        if let msgList = messages![String(describing: Common.loggedInUser!.id)] {
            return msgList as! [String]
        }
        return []
    }
    
    static func setDefaultMessages(newMessages: [String]) {
        var messages = UserDefaults.standard.dictionary(forKey: "defaultMessages")
        messages![String(describing: Common.loggedInUser!.id)] = newMessages
        UserDefaults.standard.set(messages, forKey: "defaultMessages")
        UserDefaults.standard.synchronize()
    }
    
    static func getLocalAuthAccountId() -> Int? {
        return UserDefaults.standard.value(forKey: "localAuth") as? Int
    }
    
    static func setLocalAuthAccountId(id: Int?) {
        if let val = id {
            UserDefaults.standard.set(val, forKey: "localAuth")
        } else {
            UserDefaults.standard.removeObject(forKey: "localAuth")
        }
        UserDefaults.standard.synchronize()
    }
    
    static func getAuthString() -> String? {
        let context = LAContext()
        var result: String?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let type = context.biometryType
            if type == .faceID {
                result = "Face ID"
            } else if type == .touchID {
                result = "Touch ID"
            }
        }
        context.invalidate()
        return result
    }
}
