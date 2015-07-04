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
    var chart = SimpleChart();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(chart.chartView);
        
        var result = String("{\"yellow\" : 50,\"red\" : 50,\"green\" : 50}").dataUsingEncoding(NSUTF8StringEncoding);
        chart.DrawChartWithJSON(result!);
        
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

