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
    var userID: NSString?
    var token : NSString?
    var email : NSString?
    var name : NSString?
    
    init(token _token: NSString) {
        super.init()
        self.token = _token
    }
    
    init(email _email: NSString, name _name: NSString, userID _userID: NSString) {
        super.init()
        self.email = _email
        self.name = _name
        self.userID = _userID
    }
    
    static func user(token: NSString, _completion: (UserModel?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "http://192.168.4.121:3000/api/me.json", parameters: nil, headers: ["Authorization" : NSString(format:"Bearer %@", token) as String]),
            success: { (object) -> Void in
                println(object)
                
                var email : NSString = object["email"].stringValue
                var name : NSString = object["name"].stringValue
                var userID : NSString = object["uid"].stringValue
                
                var user: UserModel = UserModel(email: email, name: name, userID: userID)

                _completion(user);
            },
            failure: { (error) -> Void in
                var error2: NSError? = error
                println(error2?.localizedDescription)
        });
    }
}