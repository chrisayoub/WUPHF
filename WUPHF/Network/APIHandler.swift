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
    
    // MARK: User operations
    
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

        Alamofire.request("\(server)/user/new", method: .post, parameters: parameters).validate().responseJSON { response in
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
        
        Alamofire.request("\(server)/user/update", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
                case .success:
                    completionHandler?(true)
                case .failure( _):
                    completionHandler?(false)
            }
        }
    }
    
    func getFriends(id: Int, completionHandler: @escaping ((_ users: [User]) -> Void)) {
        Alamofire.request("\(server)/friend/get?id=\(id)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value, let jsonDecode = json as? Array<Dictionary<String,AnyObject>> {
                    let users = self.parseUsers(json: jsonDecode)
                    completionHandler(users)
                }
            case .failure:
                completionHandler([])
            }
        }
    }
    
    // MARK: Account linking
    
    func linkSms(id: Int, number: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            "phone": number
        ]
        
        Alamofire.request("\(server)/sms/link", method: .post, parameters: parameters).validate().responseJSON { response in
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
        
        Alamofire.request("\(server)/sms/unlink", method: .post, parameters: parameters).validate().responseJSON { response in
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
        
        Alamofire.request("\(server)/facebook/link", method: .post, parameters: parameters).validate().responseJSON { response in
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
        
        Alamofire.request("\(server)/facebook/unlink", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure( _):
                completionHandler?(false)
            }
        }
    }
    
    func linkTwitter(id: Int, twId: String, oauth: String, secret: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            "twId": twId,
            "oauth": oauth,
            "secret": secret
        ]
        
        Alamofire.request("\(server)/twitter/link", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure( _):
                completionHandler?(false)
            }
        }
    }
    
    func unlinkTwitter(id: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "id": id,
            ]
        
        Alamofire.request("\(server)/twitter/unlink", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure( _):
                completionHandler?(false)
            }
        }
    }
    
    // MARK: Friend requests
    
    func searchUsers(id: Int, query: String, completionHandler: @escaping ((_ users: [User]) -> Void)) {
        Alamofire.request("\(server)/user/search?query=\(query)&id=\(id)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value, let jsonDecode = json as? Array<Dictionary<String,AnyObject>> {
                    let users = self.parseUsers(json: jsonDecode)
                    completionHandler(users)
                }
            case .failure:
                completionHandler([])
            }
        }
    }
    
    func requestUser(requester: Int, reciever: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "senderId": requester,
            "requestId": reciever
        ]
        
        Alamofire.request("\(server)/friend/request/send", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
            }
        }
    }
    
    func acceptFriendRequest(requester: Int, reciever: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "senderId": requester,
            "requestId": reciever
        ]
        
        Alamofire.request("\(server)/friend/request/accept", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
            }
        }
    }
    
    func declineFriendRequest(requester: Int, reciever: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "senderId": requester,
            "requestId": reciever
        ]
        
        Alamofire.request("\(server)/friend/request/decline", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
            }
        }
    }
    
    func getFriendRequests(id: Int, completionHandler: @escaping ((_ users: [User]) -> Void)) {
        Alamofire.request("\(server)/friend/request/get?id=\(id)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value, let jsonDecode = json as? Array<Dictionary<String,AnyObject>> {
                    let users = self.parseUsers(json: jsonDecode)
                    completionHandler(users)
                }
            case .failure:
                completionHandler([])
            }
        }
    }
    
    func deleteFriend(userId: Int, friendId: Int, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "userId": userId,
            "friendId": friendId
        ]
        
        Alamofire.request("\(server)/friend/remove", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
            }
        }
    }
    
    // MARK: WUPHF sending
    
    func sendWUPHF(userId: Int, friendId: Int, message: String, completionHandler: ((_ success: Bool) -> Void)?) {
        let parameters: Parameters = [
            "userId": userId,
            "friendId": friendId,
            "message": message
        ]
        
        Alamofire.request("\(server)/wuphf", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
            }
        }
    }
    
    // MARK: JSON parsing
    
    fileprivate func parseUsers(json: Array<Dictionary<String,AnyObject>>) -> [User] {
        var users: [User] = []
        for userStr in json {
            if let user = self.parseJsonToUser(json: userStr) {
                users.append(user)
            }
        }
        return users
    }
    
    fileprivate func parseJsonToUser(json: Dictionary<String,AnyObject>) -> User? {
        if let id = json["id"] as? Int,
        let firstName = json["firstName"] as? String,
        let lastName = json["lastName"] as? String,
        let email = json["email"] as? String,
        let phone = json["phoneNumber"] as? String,
        let enableSMS = json["enableSMS"] as? Bool,
        let facebookLinked = json["facebookLinked"] as? Bool,
        let twitterLinked = json["twitterLinked"] as? Bool {
            let user = User(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone,
                        enableSMS: enableSMS, facebookLinked: facebookLinked, twitterLinked: twitterLinked)
            if let requested = json["requested"] as? Bool {
                user.requested = requested
            }
            return user
        }
        return nil
    }
}

