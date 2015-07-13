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
#if !TODAY_EXTENSION
import OAuthSwift
#endif

let kDevServer : String = "http://localhost:3000/"
let kProductionServer : String = "http://212.55.76.132/"
let kAuthorizationServer : String = "http://fritzvl.info/"

class API : NSObject {
    
    var host : String?
    var token : String?
    
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
        // no need auth in today extension?
        #if !TODAY_EXTENSION
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
                
                UserModel.user(credential.oauth_token, _completion: { (user) -> Void in
                    var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
                    manager.user = user
                    
                    println(manager.user)
                    API.isRunAuthorization = false;
                    
                    UserModel.updatePushToken("", deviceToken: "", _completion: { (user) -> Void in
                        println(user)
                    })
                    
                })
                
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
                    API.isRunAuthorization = false;
            })
        #endif
    }

// MARK: API Call
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]? = nil) -> Request {
        // FIXME: need to add Authorization Token to headers
        var request: Request = Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.JSON)
        request.session.configuration.HTTPAdditionalHeaders = headers;
        
        println("request.headers:\n\(request.session.configuration.HTTPAdditionalHeaders!)")
        
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
                _success(json)
            }
        });
    }
}