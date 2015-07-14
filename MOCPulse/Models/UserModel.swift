//
//  UserModel.swift
//  MOCPulse
//
//  Created by Anton on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserModel : NSObject {
    var userID: String?
    var token : String?
    var email : String?
    var name : String?
    
    init(token _token: String) {
        super.init()
        self.token = _token
    }
    
    init(email _email: String, name _name: String, userID _userID: String) {
        super.init()
        self.email = _email
        self.name = _name
        self.userID = _userID
    }
    
// MARK: API Call    
    static func user(token: String, _completion: (UserModel?) -> Void) -> Request {
        
        return API.response(API.request(.GET, path: "\(kAuthorizationServer)api/me.json", headers: ["Authorization" : "Bearer \(token)"]),
            success: { (object) -> Void in
                println(object)
                
                var email : String = object["email"].stringValue
                var name : String = object["name"].stringValue
                var userID : String = object["uid"].stringValue
                
                var user: UserModel = UserModel(email: email, name: name, userID: userID)

                _completion(user);
            },
            failure: { (error : NSError?) -> Void in
                println("API.Error: \(error?.localizedDescription)")
        });
    }
    
    static func updatePushToken(_userToken userToken: String,_deviceToken deviceToken: String, _completion: (Void) -> Void) -> Request {
        return API.response(API.request(.POST, path: "\(kAuthorizationServer)/api/me/data", parameters: ["app_data" : deviceToken], headers: ["Authorization" : "Bearer \(userToken)"]), success: { (responseObject) -> Void in
            println(responseObject)
            _completion()
        }, failure: { (error) -> Void in
            var error2: NSError? = error
            println(error2?.localizedDescription)
            _completion()
        })
    }
    
}