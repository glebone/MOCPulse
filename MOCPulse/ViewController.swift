//
//  ViewController.swift
//  MOCPulse
//
//  Created by gleb on 7/3/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    @IBOutlet var authTryButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func authTryAction()
    {
        oauthAuthorization()
    }
    
    func oauthAuthorization()
    {
        let oauthswift2 = OAuth2Swift(
            consumerKey: "",
            consumerSecret: "",
            authorizeUrl: "",
            accessTokenUrl: "",
            responseType: ""
        )
        
        var urlExample = NSURL(string: "oauth-swift://oauth-callback/instagram")!
        
        oauthswift2.authorizeWithCallbackURL( urlExample,
            scope: "",
            state: "",
            params: ["" : ""],
            success: { (credential, response, parameters) -> Void in
                println(response)
        }) { (error) -> Void in
            println(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

