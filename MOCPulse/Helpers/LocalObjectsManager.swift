//
//  LocalObjectsManager.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import KeychainAccess

class LocalObjectsManager {
    
    var user : UserModel?
    
    var votes : [VoteModel]?
    
    var voteIndexSelected : Int?
    
    class var sharedInstance : LocalObjectsManager {
        struct singleton {
            static let instance : LocalObjectsManager = LocalObjectsManager();
        }
        return singleton.instance
    }

    // MARK: -
    private var token : String?
    private var keychain : Keychain {
        return Keychain(service: NSBundle.mainBundle().bundleIdentifier!)
    }
    
    func removeAllCredentials() {
        setToken(nil, server: kAuthorizationServer)
        setToken(nil, server: kProductionServer)
        user = nil;
        votes = nil;
    }
    
    func setToken(_token: String?, server _server:String!) {
        
        token = _token
        keychain[_server] = _token
        
        var tokenHash: NSInteger = (_token == nil) ? 0 : _token!.hash
        NSUserDefaults.standardUserDefaults().setInteger(tokenHash, forKey: _server)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getToken(server _server: String) -> String? {
        
        if(token == nil) {
            token = keychain[_server]
        }
        
        var tokenHash: NSInteger = NSUserDefaults.standardUserDefaults().integerForKey(_server)
        return (tokenHash != 0 && token != nil && tokenHash == token!.hash) ? token : nil;
    }
}
