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
    
    fileprivate func parseJsonToUser(json: Dictionary<String,AnyObject>) -> User? {
        if let id = json["id"] as? Int,
        let firstName = json["firstName"] as? String,
        let lastName = json["lastName"] as? String,
        let email = json["email"] as? String,
        let phone = json["phone"] as? String,
        let enableSMS = json["enableSMS"] as? Bool,
        let facebookLinked = json["facebookLinked"] as? Bool,
        let twitterLinked = json["twitterLinked"] as? Bool,
        let fbAccessToken = json["fbAccessToken"] as? AccessToken{
            return User(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone,
                        enableSMS: enableSMS, facebookLinked: facebookLinked, twitterLinked: twitterLinked, fbAccessToken: fbAccessToken)
        }
        return nil
    }
}

