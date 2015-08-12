//
//  ThanksConroller.swift
//  MOCPulse
//
//  Created by glebone on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import WatchKit
import Foundation



class ThanksController: WKInterfaceController {
    
    
    @IBOutlet weak var ThanksLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        NSNotificationCenter.defaultCenter().postNotificationName("thanksClosed", object: nil)
    }
}
