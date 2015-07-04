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

enum VoteType : Int {
    case Default = 0
    case Color = 1
}

class VoteModel : NSObject {
    var id : NSInteger?
    var name : String?
    var type : VoteType = VoteType.Default
    var result : String?
    
    override init () {
        super.init()
    }
    
    init(id _id: NSInteger, name _name: String, type _type: VoteType, result _result:String) {
        super.init()
        self.id = _id
        self.name = _name
        self.type = _type
        self.result = _result;
    }
    
    static func votes(_completion: (NSArray?) -> Void) -> Request {
        return API.response(API.request(.GET, path: "votes", parameters: nil),
            success: { (object) -> Void in
                var list: NSMutableArray = [];
                for (index: String, subJson: JSON) in object {
                    let voitsDict: Dictionary<String, JSON> = subJson[index].dictionaryValue
                    var vote: VoteModel = VoteModel();
                    vote.id = voitsDict["id"]?.intValue;
                    vote.name = voitsDict["name"]?.stringValue
//                    vote.type = voitsDict["name"]?.intValue
                    vote.result = voitsDict["result"]?.stringValue
                    list.addObject(vote);
                }
                _completion(list);
            },
            failure: { (error) -> Void in
                //
        });
    }
}