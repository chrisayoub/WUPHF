//
//  SendWUPHFViewController.swift
//  WUPHF
//
//  Created by Chris on 11/16/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import CoreLocation

class SendWUPHFViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    private var messages: [String] = []
    private var wuphfInProgess = false
    private var locationManager: CLLocationManager?
    
    var targetIds: [Int] = []
    
    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var includeLocationLbl: UILabel!
    @IBOutlet weak var includeLocation: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.layer.cornerRadius = 15.0
        txtField.layer.cornerRadius = 15.0
        
        // Set default messages
        txtField.text = ""
        messages = Common.getDefaultMessages()
        
        if CLLocationManager.locationServicesEnabled() {
            // Set up location
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else {
            hideLocation()
        }
    }

    @IBAction func sendBtn(_ sender: Any) {
        if wuphfInProgess {
            return
        }
        self.wuphfInProgess = true
        
        var myLocGMap = ""
        //http://swiftdeveloperblog.com/code-examples/determine-users-current-location-example-in-swift/
        if !includeLocation.isHidden, includeLocation.isOn {
            if let mgr = locationManager {
                mgr.startUpdatingLocation()
                let userLat = String(format: "%f", (mgr.location?.coordinate.latitude)!)
                let userLong = String(format: "%f", (mgr.location?.coordinate.longitude)!)
                myLocGMap = " -- Location: https://www.google.com/maps/place/\(userLat),\(userLong)"
                mgr.stopUpdatingLocation()
            }
        }
        let finalMsg = txtField.text + myLocGMap
        
        var totalSuccess = true
        for i in 0 ..< targetIds.count {
            APIHandler.shared.sendWUPHF(userId: Common.loggedInUser!.id,
                                        friendId: targetIds[i],
                                        message: finalMsg)
            { (success) in
                if !success {
                    totalSuccess = false
                }
                // Display message on last iteration
                if i == self.targetIds.count - 1 {
                    // Get action from navigation item title
                    let action = (self.navigationItem.title?.split(separator: " ")[1])!
                    if totalSuccess {
                        Common.alertPopUp(warning: "\(action) successful!", vc: self, completion: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        Common.alertPopUp(warning: "\(action) failed!", vc: self, completion: nil)
                    }
                    self.wuphfInProgess = false
                }
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayMessage", for: indexPath)
        cell.textLabel?.text = messages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtField.text = messages[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showLocation() {
        includeLocation.isHidden = false
        includeLocationLbl.isHidden = false
    }
    
    func hideLocation() {
        includeLocation.isHidden = true
        includeLocationLbl.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            hideLocation()
        } else {
            showLocation()
        }
    }
}
