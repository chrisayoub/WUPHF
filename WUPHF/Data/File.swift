//
//  File.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import Foundation
import UIKit

class Pack{
    
    private var _name: String
    private var _image: UIImage
    private var _members: [User] //TODO: what is the person ID in WUPHF??
    
    init(name: String, image: UIImage, members: [User]) {
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
    
    var members: [User] {
        get { return _members }
        set(data) { _members = data }
    }
    
    
}
