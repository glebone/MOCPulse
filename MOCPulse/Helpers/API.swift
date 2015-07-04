//
//  API.swift
//  MOCPulse
//
//  Created by Anton on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let kHost : NSString = "http://localhost:3000/"

class API : NSObject {
    
    var host: NSString?
    
    class var sharedInstance : API {
        struct singleton {
            static let instance = API(host:kHost)
        }
        return singleton.instance
    }
    
    init(host _host:NSString) {
        super.init()
        self.host = _host
    }
    
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible) -> Request {
        return request(_method, path: _path, parameters: nil)
    }
    
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil) -> Request {
        return Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.URL)
    }
    
    static func response(_request:Request, completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Request {
        
        return _request.responseSwiftyJSON(completionHandler);
    }
    
    static func response(_request:Request, success _success: (SwiftyJSON.JSON) -> Void, failure _failure: (NSError?) -> Void) -> Request {
        
        return self.response(_request, completionHandler: { (request, response, json, error) -> Void in
            if ((error) != nil) {
                _failure(error)
            }
            else {
                _success(json)
            }
        });
    }
}