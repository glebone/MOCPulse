//
//  LocalObjectsManager.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class LocalObjectsManager: NSObject {
    
    var user : UserModel?
    
    var votes : NSMutableArray?
    
    class var sharedInstance : LocalObjectsManager {
        struct singleton {
            static let instance = LocalObjectsManager()
        }
        return singleton.instance
    }
   
}
