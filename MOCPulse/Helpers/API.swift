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
import OAuthSwift

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
    
    static func oauthAuthorization()
    {
        let oauthswift = OAuth2Swift(
            consumerKey:    "288c7689f3eb0d5426c434413a8711534cc781751a545e431af6f7f3aa8650ee",
            consumerSecret: "0d88640d7e479c01cb37bff27cc08843e97d4b3d021e3d13449a377afeeec5f3",
            authorizeUrl:   "http://192.168.4.121:3000/oauth/authorize",
            accessTokenUrl: "http://192.168.4.121:3000/oauth/token",
            responseType:   "code"
        )
        
        let state: String = generateStateWithLength(20) as String
        
        var callbackURL = NSURL(string: "oauth-swift://oauth-callback/MOCPulse")
        
        oauthswift.authorizeWithCallbackURL( callbackURL!, scope: "public", state: state, success: {
            credential, response, parameters in
            
            UserModel.user(credential.oauth_token, _completion: { (user) -> Void in
                var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
                manager.user = user
                
                println(manager.user)
            })
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible) -> Request {
        return request(_method, path: _path, parameters: nil, headers: nil)
    }
    
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]?) -> Request {
        var manager : Manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = headers
        
        println(NSString(format:"headers:\n%@", manager.session.configuration.HTTPAdditionalHeaders!) as String)
        
        return manager.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.URL)
    }
    
//    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil) -> Request {
//        var manager : Manager = Manager.sharedInstance
//        manager.session.configuration.HTTPAdditionalHeaders = ["Authorization": ""]
//        return manager.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.URL)
//    }
    
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