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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verify(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
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
