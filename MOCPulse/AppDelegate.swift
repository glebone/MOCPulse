//
//  AppDelegate.swift
//  MOCPulse
//
//  Created by gleb on 7/3/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
    UIBackgroundTaskInvalid
 
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        // handle todays and notifications url
        if (url.scheme == "mocpulse") {
            self.handleWidgetsOpenUrl(url)
        } else {
            OAuth2Swift.handleOpenURL(url)
        }
        
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        updateGlobalUI()
        
        if(application.respondsToSelector(Selector("registerUserNotificationSettings:")))
        {
            self.setupNotifications()
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        else
        {
            application.registerForRemoteNotifications()
//            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        return true
    }
    
    func setupNotifications() {
        var voteAction = UIMutableUserNotificationAction()
        voteAction.identifier = "ID_VOTE"
        voteAction.title = "Vote"
        voteAction.destructive = false
        voteAction.authenticationRequired = false
        voteAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        var notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "newVote"
        notificationCategory .setActions([voteAction], forContext: UIUserNotificationActionContext.Default)
        
        var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes:UIUserNotificationType.Alert|UIUserNotificationType.Sound, categories: NSSet(array: [notificationCategory]) as Set<NSObject>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func handleWidgetsOpenUrl(url: NSURL)
    {
        var host = url.host
        
        switch url.host! {
        case "openvote":
            var param : [AnyObject] = url.pathComponents!
            var voteId: String = param[1] as! String
            
            NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_SHOW_VIEW", object: nil, userInfo: ["voteId":voteId])

        case "vote":
            var param : [AnyObject] = url.pathComponents!
            var strcolor: String = param[1] as! String
            var voteId: String = param[2] as! String
            
            var color : VoteColor = VoteColor.VOTE_COLOR_GREEN
            
            switch strcolor {
                case "green": color = VoteColor.VOTE_COLOR_GREEN
                case "yellow": color = VoteColor.VOTE_COLOR_YELLOW
                case "red": color = VoteColor.VOTE_COLOR_RED
                default : break
            }
            
            // need auth check?
            VoteModel.voteFor(id: voteId, color: color, completion: { (vote) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_SHOW_VIEW", object: nil, userInfo: ["vote":vote!])
            })
            
        default: break
            //println("Unknown url for scheme ", &action)
        }
    }
    
    func updateGlobalUI() {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 55.0/255, green: 55.0/255, blue: 55.0/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
        var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
        if (manager.user == nil) {
            println("Need call OAuth")
            API.oauthAuthorization()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//MARK: push notifications
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current installation and save it to Parse.
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:"<>"))
        
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        println(token)
        
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "device_push_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Recived: \(userInfo)")
        // structure example
        // {"aps":{"alert":"This is some fancy message.","badge":1, "category":"newVote", "vote":{"id":"1437029089921061910","name":"This is some fancy message.","owner":"Jack London"}}}
        
        if var aps = (userInfo as! [NSString : AnyObject])["aps"] as? NSDictionary {
            if var vote = aps["vote"] as? NSDictionary {
                var voteId = vote["id"] as! String
                var owner = vote["owner"] as! String
                var body = vote["name"] as! String
                
                NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
                
                var rateView = RateAlertView(ownerTitle: owner, voteBody: body, voteId: voteId)
                
                UIApplication.sharedApplication().keyWindow?.addSubview(rateView)
            }
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {

        if identifier == "ID_VOTE" {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                UIApplication.sharedApplication().openURL(NSURL(string: "mocpulse://openvote/1437029089921061910")!)
            }
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if var aps = (userInfo as! [NSString : AnyObject])["aps"] as? NSDictionary {
            if var vote = aps["vote"] as? NSDictionary {
                var voteId = vote["id"] as! String
    
                NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    UIApplication.sharedApplication().openURL(NSURL(string: NSString(format: "mocpulse://openvote/%@", voteId) as String)!)
                }
            }
        }
    }
    
//MARK: watch kit
    
    func application(application: UIApplication, handleWatchKitExtensionRequest
        voteInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)?) {
            
            var task = UIBackgroundTaskInvalid
            UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(task)
                task = UIBackgroundTaskInvalid
            })
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
            
            
                if let info = voteInfo as? [String : String] {
                    println(voteInfo)
                    let val = voteInfo!["value"] as? VoteColor
                    let id =  voteInfo!["id"] as? String
                    if (id == "-1") {
                        var curVote: VoteModel? = LocalObjectsManager.sharedInstance.getLastVote()
                        if curVote == nil
                        {
                           reply.map {$0 (["name" : "", "id": ""])}
                        }
                        else
                        {
                            reply.map {$0 (["name" : curVote!.name!, "id": curVote!.id!])}
                        }
                    }
                    else {
                        
                        VoteModel.voteFor(id: id!, color: val!, completion: { (vote) -> Void in
                            println("Voted!!!!)))")
                        })
                        
                        
                        reply.map { $0(["response" : "success"]) }
                    }
                } else {
                    
                    
                    reply.map { $0(["response" : "fail"]) }
                }

            }
            UIApplication.sharedApplication().endBackgroundTask(task)
            
            task = UIBackgroundTaskInvalid
    }

}

