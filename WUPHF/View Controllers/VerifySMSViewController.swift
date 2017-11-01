//
//  VerifySMSViewController.swift
//  WUPHF
//
//  Created by Chris on 10/31/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class VerifySMSViewController: UIViewController {

    @IBOutlet weak var phone: UITextField!
    
    var smsSwitch: UISwitch?
    var delegate: ModalViewControllerDelegate!
    
    @IBAction func verify(_ sender: Any) {
        if let num = phone.text, num != "", Common.isValidPhone(testStr: num) {
            delegate.sendValue(value: num)
            dismiss(animated: true, completion: nil)
        } else {
            Common.alertPopUp(warning: "Please enter a valid phone number.", vc: self)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        smsSwitch?.setOn(false, animated: true)
        dismiss(animated: true, completion: nil)
    }

}

// https://stackoverflow.com/questions/28502653/passing-data-from-modal-segue-to-parent
protocol ModalViewControllerDelegate
{
    func sendValue(value: String?)
}
