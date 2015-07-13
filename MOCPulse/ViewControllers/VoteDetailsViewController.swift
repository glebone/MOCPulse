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
    }
    
    func interfaceFotVote(vote : VoteModel) {
        if voteModel.voted == true {
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
    
    @IBAction func greenButtonAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
//        var greenColor : ColorChartObject = colorChart.getGreenColor()
//
//        greenColor.value += 10
//        
//        colorChart.reloadChart()
        
        showPulseAnimation(UIColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1))
        
        println("red: \(voteModel.redVotes) yellow: \(voteModel.yellowVotes) green: \(voteModel.greenVotes)")
        
        voteModel.voted = true
        voteModel.greenVotes = voteModel.greenVotes! + 1
        self.interfaceFotVote(voteModel)
    }
    
    @IBAction func yellowButtonAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
//        var yellowColor : ColorChartObject = colorChart.getYellowColor()
//        
//        yellowColor.value += 10
//        
//        colorChart.reloadChart()
        
        showPulseAnimation(UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1))
        
        println("red: \(voteModel.redVotes) yellow: \(voteModel.yellowVotes) green: \(voteModel.greenVotes)")
        
        voteModel.voted = true
        voteModel.yellowVotes = voteModel.yellowVotes! + 1
        self.interfaceFotVote(voteModel)
    }
    
    @IBAction func redButtonAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
//        var redColor : ColorChartObject = colorChart.getRedColor()
//        
//        redColor.value += 10
//        
//        colorChart.reloadChart()
        
        showPulseAnimation(UIColor(red: 221/255, green: 48/255, blue: 61/255, alpha: 1))
        
        println("red: \(voteModel.redVotes) yellow: \(voteModel.yellowVotes) green: \(voteModel.greenVotes)")
        
        voteModel.voted = true
        voteModel.redVotes = voteModel.redVotes! + 1
        self.interfaceFotVote(voteModel)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
