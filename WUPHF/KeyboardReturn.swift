//
//  File.swift
//  WUPHF
//
//  Created by Chris on 10/31/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class KeyboardReturn: NSObject, UITextFieldDelegate {
    
    static let shared = KeyboardReturn()
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
