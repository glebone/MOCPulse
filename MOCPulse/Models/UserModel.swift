//
//  UserModel.swift
//  MOCPulse
//
//  Created by Anton on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation


class UserModel : NSObject {
    var token : NSString?
    var email : NSString?
    var firstName : NSString?
    var lastName : NSString?
    
    var fullName : NSString {
        get {
            return "\(firstName!) \(lastName!)"
        }
    }
    
    init(token _token: NSString) {
        super.init()
        self.token = _token
    }
    
    init(email _email: NSString, firstName _firstName: NSString, lastName _lastName: NSString) {
        super.init()
        self.email = _email
        self.firstName = _firstName
        self.lastName = _lastName
    }
}