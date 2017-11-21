//
//  File.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import Foundation
import UIKit

class Pack {
    
    private var _name: String
    private var _image: UIImage
    private var _members: [Int]
    
    init(name: String, image: UIImage, members: [Int]) {
        _name = name
        _image = image
        _members = members
    }
    
    var name: String {
        get { return _name }
        set(data) { _name = data }
    }
    
    var image: UIImage {
        get { return _image }
        set(data) { _image = data }
    }
    
    var members: [Int] {
        get { return _members }
        set(data) { _members = data }
    }
    
    func toString() -> String {
        var s: String = ""
        s.append(_name)
        s.append("\n")
        let imageData = UIImagePNGRepresentation(_image)
        let strImage: String = (imageData?.base64EncodedString())!
        s.append(strImage)
        s.append("\n")
        
        for id in _members {
            s.append("\(id)")
        }
        
        return s
    }
    
    func writePack() {
        DispatchQueue.global().async {
            var packs = UserDefaults.standard.dictionary(forKey: "packs")
            let packsList = packs![String(describing: Common.loggedInUser!.id)] as! [String]
            var newPacksList: [String] = []
            
            // Update new pack with member
            for packStr in packsList {
                let strArr = packStr.components(separatedBy: "\n")
                let name: String = strArr[0]
                if name == self.name {
                    newPacksList.append(self.toString())
                } else {
                    newPacksList.append(packStr)
                }
            }
            
            packs![String(describing: Common.loggedInUser!.id)] = newPacksList
            UserDefaults.standard.set(packs, forKey: "packs")
            UserDefaults.standard.synchronize()
        }
    }
}
