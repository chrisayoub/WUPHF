//
//  APIHandler.swift
//  WUPHF
//
//  Created by Chris on 10/30/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import Foundation
import Alamofire
import FacebookCore

class APIHandler {
    
    static let shared = APIHandler()
    
    // Default value in case of failure to read current IP
    var server: String = "http://18.216.122.103"
    
    private init() {
        if let path = Bundle.main.path(forResource: "App", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                server = dic["server"] as! String
            }
        }
    }
    
    func getUser(id: Int, completionHandler: @escaping (_ user: User?) -> Void) {
        Alamofire.request("\(server)/user/get?id=\(id)").validate().responseJSON { response in
            switch response.result {
                case .success:
                    if let json = response.result.value, let jsonDecode = json as? Dictionary<String,AnyObject> {
                        let user = self.parseJsonToUser(json: jsonDecode)
                        completionHandler(user)
                    }
                case .failure( _):
                    completionHandler(nil)
            }
        }
    }
    
    func getUserByEmail(email: String, completionHandler: @escaping (_ user: User?) -> Void) {
        Alamofire.request("\(server)/user/get/byEmail?email=\(email)").validate().responseJSON { response in
             switch response.result {
                 case .success:
                    if let json = response.result.value, let jsonDecode = json as? Dictionary<String,AnyObject> {
                        let user = self.parseJsonToUser(json: jsonDecode)
                        completionHandler(user)
                    }
                 case .failure( _):
                    completionHandler(nil)
            }
        }
    }
    
    func createUser(firstName: String, lastName: String, email: String, completionHandler: ((_ id: Int?) -> Void)?) {
        let parameters: Parameters = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]

        Alamofire.request("\(server)/user/new", method: .post, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                if let data = json as? Dictionary<String,AnyObject>, let id = data["id"] as? Int {
                    completionHandler?(id)
                }
            }
        }
    }
    
    func updateUser(id: Int, firstName: String, lastName: String, email: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
        
        Alamofire.request("\(server)/user/update", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
                case .success:
                    completionHandler?(true)
                case .failure( _):
                    completionHandler?(false)
            }
        }
    }
    
    func linkSms(id: Int, number: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            "phone": number
        ]
        
        Alamofire.request("\(server)/sms/link", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
                case .success:
                    completionHandler?(true)
                case .failure( _):
                    completionHandler?(false)
            }
        }
    }
    
    func unlinkSms(id: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
        ]
        
        Alamofire.request("\(server)/sms/unlink", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
                case .success:
                    completionHandler?(true)
                case .failure( _):
                    completionHandler?(false)
            }
        }
    }
    
    func linkFacebook(id: Int, fbId: String, token: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            "fbId": fbId,
            "token": token
        ]
        
        Alamofire.request("\(server)/facebook/link", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure( _):
                completionHandler?(false)
            }
        }
    }
    
    func unlinkFacebook(id: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
        ]
        
        Alamofire.request("\(server)/facebook/unlink", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure( _):
                completionHandler?(false)
            }
        }
    }
    
    fileprivate func parseJsonToUser(json: Dictionary<String,AnyObject>) -> User? {
        
        print (json)
        
        if let id = json["id"] as? Int,
        let firstName = json["firstName"] as? String,
        let lastName = json["lastName"] as? String,
        let email = json["email"] as? String,
        let phone = json["phoneNumber"] as? String,
        let enableSMS = json["enableSMS"] as? Bool,
        let facebookLinked = json["facebookLinked"] as? Bool,
        let twitterLinked = json["twitterLinked"] as? Bool {
            return User(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone,
                        enableSMS: enableSMS, facebookLinked: facebookLinked, twitterLinked: twitterLinked)
        }
        return nil
    }
}

