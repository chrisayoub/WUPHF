//
//  User.swift
//  WUPHF
//
//  Created by Chris on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import Foundation
import FacebookCore

class User {
    
    private var _id: Int
    private var _firstName: String
    private var _lastName: String
    private var _email: String
    private var _phone: String
    private var _enableSMS: Bool
    private var _facebookLinked: Bool
    private var _twitterLinked: Bool
    
    init(id: Int, firstName: String, lastName: String, email: String, phone: String,
         enableSMS: Bool, facebookLinked: Bool, twitterLinked: Bool) {
        _id = id
        _firstName = firstName
        _lastName = lastName
        _email = email
        _phone = phone
        _enableSMS = enableSMS
        _facebookLinked = facebookLinked
        _twitterLinked = twitterLinked
        //_fbAccessToken = fbAccessToken
    }
    
    var id: Int {
        get { return _id }
        set(data) { _id = data }
    }
    
    var firstName: String {
        get { return _firstName }
        set(data) { _firstName = data }
    }
    
    var lastName: String {
        get { return _lastName }
        set(data) { _lastName = data }
    }
    
    var email: String {
        get { return _email }
        set(data) { _email = data }
    }
    
    var phone: String {
        get { return _phone }
        set(data) { _phone = data }
    }
    
    var enableSMS: Bool {
        get { return _enableSMS }
        set(data) { _enableSMS = data }
    }
    
    var facebookLinked: Bool {
        get { return _facebookLinked }
        set(data) { _facebookLinked = data }
    }
    
    var twitterLinked: Bool {
        get { return _twitterLinked }
        set(data) { _twitterLinked = data }
    }
   

}
