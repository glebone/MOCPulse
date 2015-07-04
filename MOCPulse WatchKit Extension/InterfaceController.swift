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
    var isNotification : Bool = false
    var voteId : String!
    

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        println("-----")
        
        
        super.willActivate()
        println(isNotification)
        if(!isNotification)
        {
            getVote()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func RedButtonPressed() {
        NSLog("Red action")
        if (isNotification) {
            sendParent(["Red", notificationDic["aps"]!["id"]! as! String])
        } else
        {
           sendParent(["Red" , voteId!])
        }
        pushThanks()

        
    }
    
    @IBAction func YellowButtonPressed() {
        NSLog("Yellow action")
        if (isNotification) {
            sendParent(["Yellow", notificationDic["aps"]!["id"]! as! String])
        } else
        {
            sendParent(["Yellow" , voteId!])
        }
        
        pushThanks()
     
    }
    
    @IBAction func GreenButtonPressed() {
        NSLog("Green Action")
        if (isNotification) {
            sendParent(["Green", notificationDic["aps"]!["id"]! as! String])
        } else
        {
            sendParent(["Green" , voteId!])
        }

        pushThanks()
    }
    
    
    func pushThanks() {
        pushControllerWithName("ThanksController",
            context: ["segue": "hierarchical",
                "data":"Passed through hierarchical navigation"])
    }
    
    func sendParent(value: [String]) {
        var voteInfo = ["value" : value[0], "id" : value[1]]
        WKInterfaceController.openParentApplication(voteInfo, reply: { (data, error) in
            if let error = error {
                println(error)
            }
            if let data = data {
                println(data)
            }
        })
    }
    
    func getVote() {
        var req = ["value" : "", "id" : "-1"]
        WKInterfaceController.openParentApplication(req, reply: { (data, error) in
            if let error = error {
                println(error)
            }
            if let data = data {
                println(data)
                //sendParent([data!["value"]!, data["id"]!])
                self.VoteLabel.setText(data["name"] as? String)
                self.voteId = data["id"] as! String
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
                isNotification = true
                if notificationIdentifier == "voteButtonAction" {
                    NSLog("There")
                }
            }
    }


}
