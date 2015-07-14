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

let kDevServer : String = "http://localhost:3000/"
let kProductionServer : String = "http://192.168.5.225:8080/"
let kAuthorizationServer : String = "http://fritzvl.info/"

class API : NSObject {
    
    var host : String?
    var token : String?
    
    static var userToken : String?
    
    static var isRunAuthorization: Bool = false;
    
    class var sharedInstance : API {
        struct singleton {
            static let instance = API(host:kProductionServer)
        }
        return singleton.instance
    }
    
    init(host _host:String) {
        super.init()
        self.host = _host
    }
    
// MARK: Authorization
    static func oauthAuthorization()
    {
        if (API.isRunAuthorization) {
            return
        }
        API.isRunAuthorization = true;
        
        let oauthswift = OAuth2Swift(
            consumerKey:    "288c7689f3eb0d5426c434413a8711534cc781751a545e431af6f7f3aa8650ee",
            consumerSecret: "0d88640d7e479c01cb37bff27cc08843e97d4b3d021e3d13449a377afeeec5f3",
            authorizeUrl:   "\(kAuthorizationServer)oauth/authorize",
            accessTokenUrl: "\(kAuthorizationServer)oauth/token",
            responseType:   "code"
        )
        
        let state: String = generateStateWithLength(20) as String
        
        var callbackURL = NSURL(string: "oauth-swift://oauth-callback/MOCPulse")
        
        let userClass: UserModel
        
        oauthswift.authorizeWithCallbackURL( callbackURL!, scope: "public", state: state, success: {
            credential, response, parameters in
        
            self.userToken = String(credential.oauth_token)
            
            UserModel.user(self.userToken!, _completion: { (user) -> Void in
                var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
                manager.user = user
                
                println(manager.user)
                API.isRunAuthorization = false;
                
                var token = NSUserDefaults.standardUserDefaults().stringForKey("device_push_token") as String!
                var deviceToken : String = NSUserDefaults.standardUserDefaults().objectForKey("device_push_token") as! String
                
                UserModel.updatePushToken(_userToken: self.userToken!, _deviceToken: deviceToken, _completion: { (user) -> Void in
                    println(user)
                })
            })
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
                API.isRunAuthorization = false;
        })
    }

// MARK: API Call
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]? = nil) -> Request {
        
//        if _parameters != nil {
//            println(JSON(_parameters!))
//        }
        
        // FIXME: need to add Authorization Token to headers
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers;
        var request: Request = Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.JSON)
        
        println("request.headers:\n\(Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!)")
        
        return request;
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
//                if json != nil {
//                    println("\(json)")
//                }
                _success(json)
            }
        });
    }
}