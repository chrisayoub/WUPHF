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
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var includeLocation: UISwitch!
    var targetIds: [Int] = []

    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.layer.cornerRadius = 15.0
        txtField.layer.cornerRadius = 15.0
        
        self.messages = Common.getDefaultMessages()
        if self.messages.count > 0 {
            txtField.text = self.messages[0]
        } else {
            txtField.text = ""
        }
    }

    @IBAction func sendBtn(_ sender: Any) {
        if wuphfInProgess {
            return
        }
        self.wuphfInProgess = true
        var userLat = ""
        var userLong = ""
        var myLocGMap = ""
        if(includeLocation.isOn){
            determineMyCurrentLocation()
            userLat = String(format: "%f", (locationManager.location?.coordinate.latitude)!)
            userLong = String(format: "%f", (locationManager.location?.coordinate.longitude)!)
            myLocGMap = " -- https://www.google.com/maps/place/\(userLat),\(userLong)"
            locationManager.stopUpdatingLocation()
        }
        let finalMsg = txtField.text + myLocGMap
        var totalSuccess = true
        for i in 0 ..< targetIds.count {
            print(finalMsg)
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
    //http://swiftdeveloperblog.com/code-examples/determine-users-current-location-example-in-swift/
    func determineMyCurrentLocation() {
        //locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        //manager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
