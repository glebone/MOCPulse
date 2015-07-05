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
        
        VoteModel.votes(completion: {(data) -> Void in
            LocalObjectsManager.sharedInstance.votes = data!;
        });
        
        return true
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
                    let val = voteInfo!["value"] as? String
                    let id =  voteInfo!["id"] as? String
                    if (id == "-1") {
                        reply.map {$0 (["name" : "How is pizza?", "id": "5"])}
                    }
                    else {
                        
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

