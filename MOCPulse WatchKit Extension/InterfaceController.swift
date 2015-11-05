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
    var voteDic: NSDictionary!
    var isNotification : Bool = false
    var voteId : String!
    
    @IBOutlet weak var redButton: WKInterfaceButton!
    @IBOutlet weak var yellowButton: WKInterfaceButton!
    @IBOutlet weak var greenButton: WKInterfaceButton!

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onThanksClosed:", name: "thanksClosed", object: nil)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("-----")
        
        super.willActivate()
        print(isNotification)
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
            sendParent(["Red", voteDic["id"]! as! String])
        } else
        {
           sendParent(["Red" , voteId!])
        }
        
        pushThanks()
    }
    
    @IBAction func YellowButtonPressed() {
        NSLog("Yellow action")
        if (isNotification) {
            sendParent(["Yellow", voteDic["id"]! as! String])
        } else
        {
            sendParent(["Yellow" , voteId!])
        }
        
        pushThanks()
    }
    
    @IBAction func GreenButtonPressed() {
        NSLog("Green Action")
        if (isNotification) {
            isNotification = false
            sendParent(["Green", voteDic["id"]! as! String])
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
        let voteInfo = ["value" : value[0], "id" : value[1]]
        WKInterfaceController.openParentApplication(voteInfo, reply: { (data, error) in
            if let error = error {
                print(error)
                return
            }
            self.getVote()
        })
    }
    
    func onThanksClosed(n: NSNotification) {
        getVote()
    }
    
    func getVote() {
        let req = ["value" : "", "id" : "-1"]
        WKInterfaceController.openParentApplication(req, reply: { (data, error) in
            if let error = error {
                print(error)
                return
            }

            print(data)
            let id : String = data["id"] as! String
            var name : String? = data["name"] as? String
            
            self.setButtonsVision(!id.isEmpty)
            
            if id.isEmpty {
                name = "There is no active votes =("
            }

            //sendParent([data!["value"]!, data["id"]!])
            self.VoteLabel.setText(name)
            self.voteId = id

        })
        
    }
    
    
    override func handleActionWithIdentifier(identifier: String?,
        forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
            if let notificationIdentifier = identifier {
                print(remoteNotification["aps"]!["vote"]!)
                print(remoteNotification["aps"]!["id"])
                
                //VoteLabel.setText(remoteNotification["aps"]!["alert"] as? String)
                notificationDic = remoteNotification
                voteDic = (notificationDic["aps"] as! NSDictionary)["vote"] as! NSDictionary
                VoteLabel.setText(voteDic["name"] as? String);
                voteId = voteDic["id"] as! String
                self.setButtonsVision(true)
                
                isNotification = true
                if notificationIdentifier == "voteButtonAction" {
                    NSLog("There")
                }
            }
    }

    func setButtonsVision(visible: Bool) {
        // no vision methods?
        let alpha : CGFloat = visible ? 1 : 0
        self.greenButton.setAlpha(alpha)
        self.yellowButton.setAlpha(alpha)
        self.redButton.setAlpha(alpha)
    }
}
