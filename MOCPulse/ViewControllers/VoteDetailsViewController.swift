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
    @IBOutlet var progressHolderView : UIView!
    
    @IBOutlet var greenButton : UIButton!
    @IBOutlet var yellowButton : UIButton!
    @IBOutlet var redButton : UIButton!
    
    var colorChart : ColorChart!
    
    var pulseEffect : PulseAnimation!
    
    internal var voteModel : VoteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        var screenRect : CGRect = UIScreen.mainScreen().bounds

        pulseEffect = PulseAnimation(radius: screenRect.size.width * 2, position: CGPointMake(self.view.center.x, self.view.center.y - self.navigationController!.navigationBar.frame.size.height))
        
        println("\(voteModel.name)")
        
        ownerTitleLabel.text = voteModel.owner
        voteBodyTextView.text = voteModel.name
        
        interfaceFotVote(self.voteModel)
    }
    
    func interfaceFotVote(vote : VoteModel) {
        
        println("red: \(voteModel.redVotes) yellow: \(voteModel.yellowVotes) green: \(voteModel.greenVotes)")
        
        if vote.voted == true {
            
            if colorChart == nil {
                colorChart = ColorChart(frame: CGRectMake(0, 0, progressHolderView.frame.size.width, progressHolderView.frame.size.height))
                var greenColor : ColorChartObject = colorChart.getGreenColor()
                greenColor.value = CGFloat(voteModel.greenVotes!)
                var yellowColor : ColorChartObject = colorChart.getYellowColor()
                yellowColor.value = CGFloat(voteModel.yellowVotes!)
                var redColor : ColorChartObject = colorChart.getRedColor()
                redColor.value = CGFloat(voteModel.redVotes!)
                progressHolderView!.addSubview(colorChart)
            }
            
            colorChart.reloadChart()
            
            if progressHolderView.hidden == true {
                progressHolderView.hidden = false
            }
            if buttonsHolderView.hidden == false {
                buttonsHolderView.hidden = true
            }
        }
        else {
            if progressHolderView.hidden == false {
                progressHolderView.hidden = true
            }
            if buttonsHolderView.hidden == true {
                buttonsHolderView.hidden = false
            }
        }
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
}
