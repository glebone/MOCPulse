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

let kAuthToken_FIXME = ["auth_token" : "123123"]


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
    var id : String?
    var name : String?
    var owner : String?
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
        
        self.owner = _json["owner"].stringValue
        self.create = NSDate(timeIntervalSince1970:_json["create"].doubleValue)
        
        self.greenVotes = _json["result"]["green"].intValue
        self.redVotes = _json["result"]["red"].intValue
        self.yellowVotes = _json["result"]["yellow"].intValue
        
        self.allUsers = _json["result"]["all_users"].intValue
        self.voteUsers = _json["result"]["vote_users"].intValue
    }
    
// MARK: API Call
    static func voteFor(id _id:String, color _color:VoteColor, completion _completion: (VoteModel?) -> Void) -> Request {
        let _parameters: [String : AnyObject] = ["value" : _color.hashValue]
        
        return API.response(API.request(.PUT, path: "\(kProductionServer)votes/\(_id)", parameters: _parameters, headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                println("API.Error: \(error?.localizedDescription)")
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
                println("API.Error: \(error?.localizedDescription)")
        });
    }
    
    static func votes(completion _completion: ([VoteModel]?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var list: [VoteModel] = [];

                for (index: String, subJson: JSON) in object["votes"] {
                    var vote : VoteModel = VoteModel(json: subJson)
                    list.append(vote);
                }
                _completion(list);
            },
            failure: { (error : NSError?) -> Void in
               println("API.Error: \(error?.localizedDescription)")
        });
    }
    
    static func voteByID(_id:String, completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes/\(_id)", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                println("API.Error: \(error?.localizedDescription)")
        });
    }
    
    func reloadVote(completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "\(kProductionServer)votes/\(self.id!)", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                self.update(json: object["vote"]);
                _completion(self);
            },
            failure: { (error : NSError?) -> Void in
                println("API.Error: \(error?.localizedDescription)")
        });
    }
    
    static func createVote(name:String, completion _completion: (VoteModel?) -> Void) -> Request {
        return API.response(API.request(.POST, path: "\(kProductionServer)votes", parameters: ["name" : name, "type" : "1"], headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var vote : VoteModel = VoteModel(json: object["vote"]);
                _completion(vote);
            },
            failure: { (error : NSError?) -> Void in
                println("API.Error: \(error?.localizedDescription)")
        });
    }
}