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

let kTcpServer = "pulse.masterofcode.com"
let kTcpServerPort = 4242

let kDevServer : String = "http://localhost:3000/"
let kProductionServer : String = "https://pulse.masterofcode.com/"
let kAuthorizationServer : String = "https://id.masterofcode.com/"

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
            
            let callbackURL = NSURL(string: "oauth-swift://oauth-callback/MOCPulse")
            
            oauthswift.authorizeWithCallbackURL( callbackURL!, scope: "public", state: state, success: {
                credential, response, parameters in
            
                self.userToken = String(credential.oauth_token)
                
                print("userToken: \(self.userToken)")
            
                NSUserDefaults.standardUserDefaults().setObject(self.userToken, forKey: "user_tmp_token")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let deviceToken : String? = NSUserDefaults.standardUserDefaults().objectForKey("device_push_token") as? String
            
                TcpSocket.sharedInstance.connect(kTcpServer, port: kTcpServerPort)
            
                kHardCodedToken = self.userToken!
                
                if deviceToken == nil {
                    print("no device token yet")
                    
                    self.getUser(_userToken: self.userToken!)
                }
                else {
                    print("device token: \(deviceToken)")
                    
                    self.putPushToken(_pushToken: deviceToken!, _userToken: self.userToken!)
                }
            
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
                API.isRunAuthorization = false;
            })
        #endif
    }
    
    static func putPushToken(_pushToken pushToken : String, _userToken userToken : String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_tmp_token")
        NSUserDefaults.standardUserDefaults().synchronize()
        UserModel.updatePushToken(_userToken: userToken, _deviceToken: pushToken, _completion: { () -> Void in
            self.getUser(_userToken: userToken)
        })
    }
    
    static func getUser(_userToken userToken : String) {
        UserModel.user(userToken, _completion: { (user:UserModel?) -> Void in
            let manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
            manager.user = user
            
            kHardCodedToken = user?.apiToken
            
            API.isRunAuthorization = false
            
//            println(user)
            
            NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("DID_AUTH", object: nil)
        })
    }
    
// MARK: API Call
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]? = nil) -> Request {
        
        if _parameters != nil {
//            println(JSON(_parameters!))
        }
        
        let request: Request = Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.JSON, headers: headers as? [String:String])
        
//        println("request.headers:\n\(Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!)")
        
        return request;
    }
    
    static func requestWithoutJSON(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]? = nil) -> Request {
        
        //        if _parameters != nil {
        //            println(JSON(_parameters!))
        //        }
        
        let request: Request = Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.URL, headers: headers as? [String:String])
        
        //        println("request.headers:\n\(Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!)")
        
        return request;
    }
        
    static func response(_request:Request, completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Request {
        
        return _request.responseSwiftyJSON(completionHandler);
    }
    
    static func response(_request:Request, success _success: (SwiftyJSON.JSON) -> Void, failure _failure: (NSError?) -> Void) -> Request {
        
        return self.response(_request, completionHandler: { (request, response, json, error) -> Void in

//            println("\n\(_request.debugDescription)\n")

            if ((error) != nil) {
                 print("\nerror:!!! \(error)\n")
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