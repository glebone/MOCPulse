//
//  VoteDetailsViewController.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import AudioToolbox

class VoteDetailsViewController: UIViewController {

    @IBOutlet var ownerTitleLabel : UILabel!
    
    @IBOutlet var voteBodyTextView : UITextView!
    
    @IBOutlet var buttonsHolderView : UIView!
    @IBOutlet weak var colorChart: ColorChart!
    
    @IBOutlet var greenButton : UIButton!
    @IBOutlet var yellowButton : UIButton!
    @IBOutlet var redButton : UIButton!
    
    var pulseEffect : PulseAnimation!
    
    internal var voteModel : VoteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateVote:", name:"voteUpdated", object: nil)
        
        TcpSocket.sharedInstance.reconnectIfNeeded()
        
        setupView()
    }
    
    func setupView() {
        var screenRect : CGRect = UIScreen.mainScreen().bounds

        pulseEffect = PulseAnimation(radius: screenRect.size.width * 2, position: CGPointMake(self.view.center.x, self.view.center.y ))
        
        println("\(voteModel.name)")
        
        ownerTitleLabel.text = voteModel.displayOwnerName()
        voteBodyTextView.text = voteModel.name
        
        interfaceFotVote(self.voteModel)
    }
    
    func interfaceFotVote(vote : VoteModel) {
        
        println("red: \(vote.redVotes) yellow: \(vote.yellowVotes) green: \(vote.greenVotes)")
        voteModel = vote
        
        if vote.voted == true {
            var greenColor : ColorChartObject = colorChart.getGreenColor()
            greenColor.value = CGFloat(voteModel.greenVotes!)
            var yellowColor : ColorChartObject = colorChart.getYellowColor()
            yellowColor.value = CGFloat(voteModel.yellowVotes!)
            var redColor : ColorChartObject = colorChart.getRedColor()
            redColor.value = CGFloat(voteModel.redVotes!)
            
            colorChart.reloadChart()
            
            if colorChart.hidden == true {
                colorChart.hidden = false
            }
            if buttonsHolderView.hidden == false {
                buttonsHolderView.hidden = true
            }
        }
        else {
            if colorChart.hidden == false {
                colorChart.hidden = true
            }
            if buttonsHolderView.hidden == true {
                buttonsHolderView.hidden = false
            }
        }
        
        LocalObjectsManager.sharedInstance.replaceVoteIfExists(vote)
    }
    
    func voteForColor(voteColor:VoteColor) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        showPulseAnimation(voteColor.color)
        
        voteModel.voteFor(color: voteColor, completion:  { (vote:VoteModel?) -> Void in
            self.interfaceFotVote(vote!)
        })
    }
    
    @IBAction func greenButtonAction() {
        
        voteForColor(.VOTE_COLOR_GREEN)
    }
    
    @IBAction func yellowButtonAction() {
        
        voteForColor(.VOTE_COLOR_YELLOW)
    }
    
    @IBAction func redButtonAction() {
        
        voteForColor(.VOTE_COLOR_RED)
    }
    
    func showPulseAnimation(color : UIColor) {
        if (pulseEffect.superlayer == nil) {
            view.layer.insertSublayer(pulseEffect, below: self.view.layer)
        }
        
        pulseEffect.backgroundColor = color.CGColor
        pulseEffect.addAnimation(pulseEffect.animationGroup, forKey: "pulse")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateVote(n: NSNotification) {
        var newVote : VoteModel = n.object as! VoteModel
        if (newVote.id == voteModel.id) {
            interfaceFotVote(newVote)
        }
    }
}
