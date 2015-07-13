//
//  LoadingViewController.swift
//  MOCPulse
//
//  Created by Admin on 12.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import NotificationCenter

class LoadingViewController: UIViewController, NCWidgetProviding {

    let viewHeight : CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateSize()
        VoteModel.votes(completion: { (arr) -> Void in
            LocalObjectsManager.sharedInstance.votes = arr
            
            var lastVote = LocalObjectsManager.sharedInstance.getLastVote()
            if lastVote == nil {
                return
            }

            if (lastVote?.voted == true) {
                self.performSegueWithIdentifier("showVotes", sender: nil)
            } else {
                self.pushToLastVote(lastVote!)
            }
        })
    }
    
    func pushToLastVote(vote: VoteModel) {
        let lasVoteVC = self.storyboard!.instantiateViewControllerWithIdentifier("LastVoteVC") as! LastVoteViewController
        lasVoteVC.vote = vote
        self.navigationController?.pushViewController(lasVoteVC, animated: true)
    }
    
    func updateSize() {
        var preferredSize = self.preferredContentSize
        preferredSize.height = viewHeight
        self.preferredContentSize = preferredSize
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }

}
