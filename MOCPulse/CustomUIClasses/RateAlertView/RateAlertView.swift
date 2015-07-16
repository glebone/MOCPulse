//
//  RateAlertView.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 11.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import AudioToolbox

class RateAlertView: UIView {

    var pulseEffect : PulseAnimation!
    
    var voteId : String!
    
    init(ownerTitle: String, voteBody: String, voteId: String) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.voteId = voteId
        
        var screenRect : CGRect = UIScreen.mainScreen().bounds
        
        pulseEffect = PulseAnimation(radius: screenRect.size.width * 2, position: CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2))
        
        self.backgroundColor = UIColor.clearColor()
        
        var backView = UIView(frame: self.bounds)
        backView.backgroundColor = UIColor.blackColor()
        backView.alpha = 0.5
        self.addSubview(backView)
        
        var containerView = UIView(frame: CGRectMake(30, 100, UIScreen.mainScreen().bounds.width - 60, 300))
        containerView.backgroundColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1)
        containerView.layer.cornerRadius = 5
//        containerView.clipsToBounds = true
        self.addSubview(containerView)
        
        var ownerTitleLabel = UILabel(frame: CGRectMake(5, 30, containerView.frame.size.width - 10, 25))
        ownerTitleLabel.numberOfLines = 1
        ownerTitleLabel.text = ownerTitle
        ownerTitleLabel.textColor = UIColor.blackColor()
        ownerTitleLabel.textAlignment = NSTextAlignment.Center
        ownerTitleLabel.font = UIFont.systemFontOfSize(14)
        ownerTitleLabel.minimumScaleFactor = 0.5
        containerView.addSubview(ownerTitleLabel)
        
        var voteBodyTextView = UITextView(frame: CGRectMake(15, 70, containerView.frame.size.width - 30, 128))
        voteBodyTextView.font = UIFont.systemFontOfSize(16)
        voteBodyTextView.text = voteBody
        voteBodyTextView.textAlignment = NSTextAlignment.Center
        voteBodyTextView.backgroundColor = UIColor.clearColor()
        voteBodyTextView.selectable = false
        containerView.addSubview(voteBodyTextView)
        
        var voteButtons = UIView(frame: CGRectMake(0, 215, containerView.frame.size.width, 85))
        
        var maskLayer = CAShapeLayer()
        var roundedPath = UIBezierPath(roundedRect: voteButtons.bounds, byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight, cornerRadii: CGSizeMake(5.0, 5.0))
        maskLayer.fillColor = UIColor.whiteColor().CGColor;
        maskLayer.backgroundColor = UIColor.clearColor().CGColor;
        maskLayer.path = roundedPath.CGPath;
        
        voteButtons.layer.mask = maskLayer
        
        voteButtons.clipsToBounds = true
        
        containerView.addSubview(voteButtons)
        
        var redButton = UIButton(frame: CGRectMake(0, 0, voteButtons.frame.size.width / 3, 100))
        redButton.backgroundColor = UIColor(red: 221.0/255, green: 48.0/255, blue: 61.0/255, alpha: 1)
        redButton.addTarget(self, action: "redButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        voteButtons.addSubview(redButton)
        
        var yellowButton = UIButton(frame: CGRectMake(voteButtons.frame.size.width / 3, 0, voteButtons.frame.size.width / 3, 100))
        yellowButton.backgroundColor = UIColor(red: 252.0/255, green: 210.0/255, blue: 56.0/255, alpha: 1)
        yellowButton.addTarget(self, action: "yellowButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        voteButtons.addSubview(yellowButton)
        
        var greenButton = UIButton(frame: CGRectMake(voteButtons.frame.size.width / 3 * 2, 0, voteButtons.frame.size.width / 3, 100))
        greenButton.backgroundColor = UIColor(red: 130.0/255, green: 177.0/255, blue: 17.0/255, alpha: 1)
        greenButton.addTarget(self, action: "greenButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        voteButtons.addSubview(greenButton)
        
        containerView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        
        var closeButton = UIButton(frame: CGRectMake(containerView.frame.size.width - 30, -10, 40, 40))
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.setTitle("X", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        closeButton.addTarget(self, action: "closeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(closeButton)
        
        var xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = (-25)
        xAxis.maximumRelativeValue = (25)
        
        var yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = (-50);
        yAxis.maximumRelativeValue = (50);
        
        containerView.addMotionEffect(xAxis)
        containerView.addMotionEffect(yAxis)
    }
    
    func redButtonAction(sender:UIButton!) {
        animateAndRate(UIColor(red: 221/255, green: 48/255, blue: 61/255, alpha: 1), colorType: VoteColor.VOTE_COLOR_RED)
    }
    
    func greenButtonAction(sender:UIButton!) {
        animateAndRate(UIColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1), colorType: VoteColor.VOTE_COLOR_GREEN)
    }
    
    func yellowButtonAction(sender:UIButton!) {
        animateAndRate(UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1), colorType: VoteColor.VOTE_COLOR_YELLOW)
    }
    
    func closeButtonAction(sender:UIButton!) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.removeFromSuperview()
        })
    }
    
    func animateAndRate(color: UIColor, colorType: VoteColor) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        if (pulseEffect.superlayer == nil) {
            self.layer.insertSublayer(pulseEffect, below: self.layer)
        }
        
        pulseEffect.backgroundColor = color.CGColor
        pulseEffect.addAnimation(pulseEffect.animationGroup, forKey: "pulse")
        
        VoteModel.voteFor(id: voteId, color: colorType, completion: { (vote) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_SHOW_VIEW", object: nil, userInfo: ["vote":vote!])
        })
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.25 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.alpha = 0.0
                }, completion: { (completed) -> Void in
                    self.removeFromSuperview()
            })
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
