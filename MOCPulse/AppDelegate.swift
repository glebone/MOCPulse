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
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var pendingNotification: NSDictionary?
    var handleNotificationActioonAfterLogin: Bool = false
    var window: UIWindow?
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
    UIBackgroundTaskInvalid
    


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
        
        Fabric.with([Crashlytics()])
        
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
        TcpSocket.sharedInstance.close()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
        let manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
        if (manager.user == nil) {
            print("Need call OAuth")
            API.oauthAuthorization()
        } else {
            TcpSocket.sharedInstance.reconnectIfNeeded()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//MARK: push notifications
    
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
        
        var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[UIUserNotificationType.Alert, UIUserNotificationType.Sound], categories: NSSet(array: [notificationCategory]) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current installation and save it to Parse.
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:"<>"))
        
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "device_push_token")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let userToken : String? = NSUserDefaults.standardUserDefaults().objectForKey("user_tmp_token") as? String
        
        if userToken != nil {
            API.putPushToken(_pushToken: token, _userToken: userToken!)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Recived: \(userInfo)")
        // structure example
//            {"aps":
//                {
//                    "alert":"Vote from Paul",
//                    "title":"MOC Pulse",
//                    "category":"newVote",
//                    "vote":
//                    {
//                        "id":"1439287367052059586",
//                        "name":"Vote from Paul",
//                        "owner":
//                        {
//                            "id":"a5741998-1d90-4db7-92a7-1fae08123d5a",
//                            "email":"",
//                            "first_name":
//                            "Paul",
//                            "last_name":"Kovalenko",
//                            "device":0,
//                            "dev_id":"985e7fd66cf512fde5bddbf302e8753d55092f13210597a9922b3d623bfb2ead"
//                        },
//                        "date":1439287367,
//                        "voted":true,
//                        "result":
//                        {
//                            "yellow":0,
//                            "green":0,
//                            "red":0,
//                            "all_users":16,
//                            "vote_users":0
//                        }
//                    }
//                },
//                "WatchKit Simulator Actions":[{"title":"Vote","identifier":"voteButtonAction"}]}
        
        if let aps = (userInfo as! [NSString : AnyObject])["aps"] as? NSDictionary {
            
            if let voteDict = aps["vote"] as? NSDictionary {
                
                let voteId = voteDict["id"] as! String
                let voteName = voteDict["name"] as! String
                
                var ownerName : String = String()
                
                let ownerDict = voteDict["owner"] as! NSDictionary

                let firstName = ownerDict["first_name"] as! String
                let lastName = ownerDict["last_name"] as! String
                
                if !firstName.isEmpty
                    && !lastName.isEmpty {
                        ownerName = String(format:"%@ %@", firstName, lastName)
                }
                else if !firstName.isEmpty {
                    ownerName = firstName
                }
                else if !lastName.isEmpty {
                    ownerName = lastName
                }

                let rateView = RateAlertView(ownerTitle: ownerName, voteBody: voteName, voteId: voteId)
                
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
        pendingNotification = (userInfo as! [NSString : AnyObject])["aps"] as? NSDictionary
        
        if (LocalObjectsManager.sharedInstance.user == nil) {
            handleNotificationActioonAfterLogin = true
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                API.oauthAuthorization()
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotificationAction:", name:"DID_AUTH", object: nil)
            }
            return
        }
        
        self.handleNotificationAction()
    }
    
    func handleNotificationAction(n: NSNotification) {
        handleNotificationAction()
    }
    
    func handleNotificationAction() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(250 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
            if (self.handleNotificationActioonAfterLogin == true) {
                NSNotificationCenter.defaultCenter().removeObserver(self);
            }
            
            if let vote = self.pendingNotification!["vote"] as? NSDictionary {
                let voteId = vote["id"] as! String
                UIApplication.sharedApplication().openURL(NSURL(string: NSString(format: "mocpulse://openvote/%@", voteId) as String)!)
            }
            
            self.handleNotificationActioonAfterLogin = false
        }
    }
    
//MARK: url handeling
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // handle todays and notifications url
        if (url.scheme == "mocpulse") {
            self.handleWidgetsOpenUrl(url)
        } else {
            OAuth2Swift.handleOpenURL(url)
        }
        return true
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
    
//MARK: watch kit
    
//    application
    
    func application(application: UIApplication,
        handleWatchKitExtensionRequest voteInfo: [NSObject : AnyObject]?,
        reply: ([NSObject : AnyObject]?) -> Void) {
            var task = UIBackgroundTaskInvalid
            UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(task)
                task = UIBackgroundTaskInvalid
            })
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                if let info = voteInfo as? [String : String] {
                    print(voteInfo)
                    let val = voteInfo!["value"] as? String
                    let id =  voteInfo!["id"] as? String
                    if (id == "-1") {
                        LocalObjectsManager.sharedInstance.sortVotesByDate()
                        var curVote: VoteModel? = LocalObjectsManager.sharedInstance.getLastVote()
                        if curVote == nil
                        {
//                            reply.map {$0 (["name" : "", "id": ""])}
                        }
                        else
                        {
//                            reply.map {$0 (["name" : curVote!.name!, "id": curVote!.id!])}
                        }
                    }
                    else {
                        var color : VoteColor = VoteColor.VOTE_COLOR_GREEN
                        switch val! {
                        case "Green": color = VoteColor.VOTE_COLOR_GREEN
                        case "Yellow": color = VoteColor.VOTE_COLOR_YELLOW
                        case "Red": color = VoteColor.VOTE_COLOR_RED
                        default : break
                        }
                        
                        VoteModel.voteFor(id: id!, color: color, completion: { (vote) -> Void in
                            var votetmp : VoteModel? = LocalObjectsManager.sharedInstance.getVoteById(vote!.id)
                            if (votetmp != nil) {
                                votetmp!.voted = true
                            } else {
                                LocalObjectsManager.sharedInstance.votes! += [vote!]
                                vote!.voted = true
                            }
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
                            print("Voted!!!!)))")
                        })
                        
                        
//                        reply.map { $0(["response" : "success"]) }
                    }
                } else {
                    
                    
//                    reply.map { $0(["response" : "fail"]) }
                }

            }
            UIApplication.sharedApplication().endBackgroundTask(task)
            
            task = UIBackgroundTaskInvalid
    }

}

