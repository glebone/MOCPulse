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

    let viewHeight : CGFloat = 120.0
    
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
        kHardCodedToken = "123123"

        VoteModel.votes(completion: { (arr: [VoteModel]?) -> Void in
            if arr?.count < 0 {
                return
            }
            
            LocalObjectsManager.sharedInstance.votes = arr
            LocalObjectsManager.sharedInstance.sortVotesByDate()
            
            let lastVotedVote = LocalObjectsManager.sharedInstance.getLastVote()
            if lastVotedVote == nil {
                self.performSegueWithIdentifier("showVotes", sender: nil)
                return
            }
            
            if (lastVotedVote?.voted == true) {
                self.performSegueWithIdentifier("showVotes", sender: nil)
            } else {
                self.pushToLastVote(lastVotedVote!)
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
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }

}
