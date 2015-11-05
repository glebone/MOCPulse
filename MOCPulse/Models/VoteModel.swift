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
import VBPieChart

var kHardCodedToken : String!
var kAuthToken_FIXME = ["auth_token" : kHardCodedToken]


enum VoteColor : Int {
    case VOTE_COLOR_RED = 0
    case VOTE_COLOR_YELLOW = 1
    case VOTE_COLOR_GREEN = 2
    
    var description : String {
        switch self {
        case .VOTE_COLOR_GREEN: return "VOTE_COLOR_GREEN";
        case .VOTE_COLOR_RED: return "VOTE_COLOR_RED";
        case .VOTE_COLOR_YELLOW: return "VOTE_COLOR_YELLOW";
        }
    }
    
    var color : UIColor {
        switch self {
        case .VOTE_COLOR_GREEN: return UIColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1);
        case .VOTE_COLOR_RED: return UIColor(red: 221/255, green: 48/255, blue: 61/255, alpha: 1);
        case .VOTE_COLOR_YELLOW: return UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1);
        }
    }
    
    var forPieChart : UIColor {
        switch self {
        case .VOTE_COLOR_GREEN: return UIColor(hexString: "00bf20");
        case .VOTE_COLOR_RED: return UIColor(hexString: "fb250d");
        case .VOTE_COLOR_YELLOW: return UIColor(hexString: "ffc000");
        }
    }
}


class VoteModel : NSObject {
    var id : String!
    var name : String!
    var ownerFirstName : String!
    var ownerLastName : String!
    
    var create : NSDate?
    var voted : Bool! = false

    var greenVotes : Int! = 0
    var redVotes : Int! = 0
    var yellowVotes : Int! = 0

    var allUsers : Int! = 0
    var voteUsers : Int! = 0
    
    override init () {
        super.init()
    }
    
    init(id _id: String, name _name: String) {
        super.init()
        
        self.id = _id
        self.name = _name
    }
    
    init(json _json:SwiftyJSON.JSON)
    {
        super.init()
        update(json: _json)
    }
    
    func update(json _json:SwiftyJSON.JSON)
    {
        self.id = _json["id"].stringValue
        self.name = _json["name"].stringValue
        
        self.ownerFirstName = _json["owner"]["first_name"].stringValue
        self.ownerLastName = _json["owner"]["last_name"].stringValue
        self.create = NSDate(timeIntervalSince1970:_json["date"].doubleValue)
        
        self.voted = _json["voted"].boolValue
        
        self.greenVotes = _json["result"]["green"].intValue
        self.redVotes = _json["result"]["red"].intValue
        self.yellowVotes = _json["result"]["yellow"].intValue
        
        self.allUsers = _json["result"]["all_users"].intValue
        self.voteUsers = _json["result"]["vote_users"].intValue
    }
    
    internal func displayOwnerName() -> String {
        var ownerName : String!
        
        if (self.ownerFirstName != nil
            && self.ownerLastName != nil) {
                ownerName = "\(self.ownerFirstName as String!) \(self.ownerLastName as String!)"
        }
        else if (self.ownerFirstName != nil) {
            ownerName = self.ownerFirstName! as String!
        }
        else if (self.ownerLastName != nil) {
            ownerName = self.ownerLastName! as String!
        }
        
        return ownerName
    }
    
    func isNewerThan(vote: VoteModel) -> Bool {
        var result = false
        
        if (self.create?.compare(vote.create!) == NSComparisonResult.OrderedDescending) {
            result = true
        }
        
        return result
    }
    
    static func jsonToVotes(data: JSON) -> [VoteModel] {
        var list: [VoteModel] = [];
        
        for (_, subJson): (String, JSON) in data["votes"] {
//            println(subJson)
            let vote : VoteModel = VoteModel(json: subJson)
            list.append(vote);
        }
        
        return list
    }
    
// MARK: API Call
    static func voteFor(id _id:String, color _color:VoteColor, completion _completion: (VoteModel?) -> Void) -> Request {
        let _parameters: [String : AnyObject] = ["value" : _color.hashValue]
        
        return API.response(API.request(.PUT, path: "\(kProductionServer)votes/\(_id)", parameters: _parameters, headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                let vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyError", object: "Can`t vote for.\n \(error!.localizedDescription)")
        });
    }
    
    func voteFor(color _color:VoteColor, completion _completion: (VoteModel?) -> Void) -> Request {
        let _parameters: [String : AnyObject] = ["value" : _color.hashValue]
        
        return API.response(API.request(.PUT, path: "\(kProductionServer)votes/\(id!)", parameters: _parameters, headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                self.update(json: object["vote"]);
                _completion(self);
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
        });
    }
    
    static func votes(completion _completion: ([VoteModel]?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                 _completion(self.jsonToVotes(object))
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyError", object: "Can`t get votes list.\n \(error!.localizedDescription)")
        });
    }
    
    static func voteByID(_id:String, completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes/\(_id)", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                let vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyError", object: "Can`t get vote.\n \(error!.localizedDescription)")
        });
    }
    
    func reloadVote(completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes/\(self.id!)", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                self.update(json: object["vote"]);
                _completion(self);
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyError", object: "Can`t reload votes.\n \(error!.localizedDescription)")
        });
    }
    
    static func createVote(name:String, completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.POST, path: "\(kProductionServer)votes", parameters: ["name" : name, "type" : "1"], headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                let vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyError", object: "Can`t create vote.\n \(error!.localizedDescription)")
        });
    }
}