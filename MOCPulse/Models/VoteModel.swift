//
//  VoteModel.swift
//  MOCPulse
//
//  Created by Anton on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum VoteType : NSInteger {
    case Default = 0
    case Color = 1
}

class VoteModel : NSObject {
    var id : String?
    var name : String?
    var type : VoteType = VoteType.Default
    var result : String?
    var greenVotes : NSInteger?
    var redVotes : NSInteger?
    var yellowVotes : NSInteger?
    var allUsers : NSInteger?
    var voteUsers : NSInteger?
    
    override init () {
        super.init()
    }
    
    init(id _id: String, name _name: String, greenVotes _greenVotes: NSInteger, redVotes _redVotes: NSInteger, yellowVotes  _yellowVotes: NSInteger) {
        super.init()
        self.id = _id
        self.name = _name;
        self.greenVotes = _greenVotes;
        self.redVotes = _redVotes;
        self.yellowVotes = _yellowVotes;
        
        //self.type = _type;
        //self.result = _result;
    }
    
    static func votes(_completion: (NSMutableArray?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "http://192.168.4.63:8080/votes", parameters: nil, headers: ["auth_token" : "123123"]),
            success: { (object) -> Void in
                var list: NSMutableArray = [];

                for (index: String, subJson: JSON) in object["votes"]{

                    var voteID = subJson["id"].string;
                    var voteName = subJson["name"].string;
                    
                    var greenVotes = subJson["result"]["green"].intValue;
                    var redVotes = subJson["result"]["red"].intValue;
                    var yellowVotes = subJson["result"]["yellow"].intValue;
                
                    var allUsers = subJson["result"]["all_users"].intValue;
                    var voteUsers = subJson["result"]["vote_users"].intValue;
                    
                    var vote : VoteModel = VoteModel(id: voteID!, name: voteName!, greenVotes: greenVotes, redVotes: redVotes, yellowVotes: yellowVotes);
                    vote.allUsers = allUsers;
                    vote.voteUsers = voteUsers;
                
                    list.addObject(vote);
                }
                _completion(list);
            },
            failure: { (error) -> Void in
                var error2: NSError? = error
                println(error2?.localizedDescription)
        });
    }
}