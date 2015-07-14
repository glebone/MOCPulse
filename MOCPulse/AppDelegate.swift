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
        println(url)
        OAuth2Swift.handleOpenURL(url)
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        updateGlobalUI()
        
        if(application.respondsToSelector(Selector("registerUserNotificationSettings:")))
        {
            var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes:UIUserNotificationType.Alert|UIUserNotificationType.Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        else
        {
            application.registerForRemoteNotifications()
//            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        return true
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
//            API.oauthAuthorization()
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
        //Parsing userinfo:
//        var temp : NSDictionary = userInfo
//        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
//        {
//            var alertMsg = info["alert"] as! String
//            var alert: UIAlertView!
//            alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
//        }
        
        var rateView = RateAlertView(ownerTitle: "Owner", voteBody: "Vote body string")
        
        UIApplication.sharedApplication().keyWindow?.addSubview(rateView)
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

