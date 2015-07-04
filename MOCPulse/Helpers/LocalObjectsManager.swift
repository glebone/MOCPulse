//
//  LocalObjectsManager.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class LocalObjectsManager {
    
    var user : UserModel?
    
    var votes : NSMutableArray = []
    
    var voteIndexSelected : Int?
    
    class var sharedInstance : LocalObjectsManager {
        struct singleton {
            static let instance : LocalObjectsManager = LocalObjectsManager();
        }
        return singleton.instance
    }
   
}
