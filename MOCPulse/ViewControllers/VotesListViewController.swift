//
//  VotesListViewController.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import OAuthSwift

class VotesListViewController: UIViewController {

    @IBOutlet var authTryButton : UIButton!
    
    var colorChart : ColorChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
    }
    
    @IBAction func authTryAction()
    {
        oauthAuthorization()
    }
    
    func oauthAuthorization()
    {
        let oauthswift = OAuth2Swift(
            consumerKey:    "288c7689f3eb0d5426c434413a8711534cc781751a545e431af6f7f3aa8650ee",
            consumerSecret: "0d88640d7e479c01cb37bff27cc08843e97d4b3d021e3d13449a377afeeec5f3",
            authorizeUrl:   "http://192.168.4.121:3000/oauth/authorize",
            accessTokenUrl: "http://192.168.4.121:3000/oauth/token",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        
        var callbackURL = NSURL(string: "oauth-swift://oauth-callback/MOCPulse")
        
        oauthswift.authorizeWithCallbackURL( callbackURL!, scope: "public", state: state, success: {
            credential, response, parameters in
            
            var alert = UIAlertController(title: "Your token is:", message: credential.oauth_token, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
