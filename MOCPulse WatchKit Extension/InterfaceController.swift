//
//  InterfaceController.swift
//  MOCPulse WatchKit Extension
//
//  Created by gleb on 7/3/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var VoteLabel: WKInterfaceLabel!
    
    var notificationDic: NSDictionary!

    
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
    }
    
    
    @IBAction func RedButtonPressed() {
        NSLog("Yellow action")
        sendParent(["Yellow", notificationDic["aps"]!["alert"]! as! String])
        pushThanks()

        
    }
    
    @IBAction func YellowButtonPressed() {
        NSLog("Yellow action")
        pushThanks()
     
    }
    
    @IBAction func GreenButtonPressed() {
        NSLog("Green Action")
        pushThanks()
    }
    
    
    func pushThanks() {
        pushControllerWithName("ThanksController",
            context: ["segue": "hierarchical",
                "data":"Passed through hierarchical navigation"])
    }
    
    func sendParent(value: [String]?) {
        var userInfo = ["personName" : "wqeqwe"]
        WKInterfaceController.openParentApplication(userInfo, reply: { (data, error) in
            if let error = error {
                println(error)
            }
            if let data = data {
                println(data)
            }
        })
    }
    
    
    override func handleActionWithIdentifier(identifier: String?,
        forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
            if let notificationIdentifier = identifier {
                println(remoteNotification["aps"]!["alert"])
                println(remoteNotification["aps"]!["id"])
                
                VoteLabel.setText(remoteNotification["aps"]!["alert"] as? String)
                notificationDic = remoteNotification
                if notificationIdentifier == "voteButtonAction" {
                    NSLog("There")
                }
            }
    }


}
