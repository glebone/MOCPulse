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
            failure: { (error) -> Void in
                println("API.Error: \(error?.localizedDescription)")
        });
    }
}