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
    
    static func user(_completion: (NSArray?) -> Void) -> Request {
        return API.response(API.request(.POST, path: "http://192.168.4.121:3000/api/me.json", parameters: nil),
            success: { (object) -> Void in
                var list: NSMutableArray = [];
                for (index: String, subJson: JSON) in object {
                    
                    let voitsDict: Dictionary<String, JSON> = subJson[index].dictionaryValue
                    
                    var voteID : NSInteger = voitsDict["id"]!.intValue;
                    var voteName : NSString = voitsDict["name"]!.stringValue
                    var voteResult : NSString = voitsDict["result"]!.stringValue
                    
                    var vote: VoteModel = VoteModel(id: voteID, name: voteName as String, type: VoteType.Color, result: voteResult as String)
                    
                    list.addObject(vote);
                }
                _completion(list);
            },
            failure: { (error) -> Void in
                //
        });
    }
}