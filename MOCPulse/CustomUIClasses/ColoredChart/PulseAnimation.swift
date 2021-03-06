//
//  PulseAnimation.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 09.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class PulseAnimation: CALayer {
    var radius:                 CGFloat = 200.0
    var fromValueForAlpha:      Float = 0.45
    var keyTimeForHalfOpacity:  Float = 0.2
    var animationDuration:      NSTimeInterval = 1.0
    var useTimingFunction:      Bool = true
    var animationGroup:         CAAnimationGroup = CAAnimationGroup()
    
    override init!(layer: AnyObject!) {
        super.init(layer: layer)
    }
    
    init(radius: CGFloat, position: CGPoint) {
        super.init()
        self.contentsScale = UIScreen.mainScreen().scale
        self.opacity = 0.0
        self.backgroundColor = UIColor.blueColor().CGColor
        self.radius = radius;
        self.position = position
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.setupAnimationGroup()
            self.setPulseRadius(self.radius)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPulseRadius(radius: CGFloat) {
        self.radius = radius
        var tempPos = self.position
        var diameter = self.radius * 2
        
        self.bounds = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
        self.cornerRadius = self.radius
        self.position = tempPos
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = self.animationDuration
        self.animationGroup.removedOnCompletion = false
        
        if self.useTimingFunction {
            var defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            self.animationGroup.timingFunction = defaultCurve
        }
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        var scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(float: 0.0)
        scaleAnimation.toValue = NSNumber(float: 1.0)
        scaleAnimation.duration = self.animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        var opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = self.animationDuration
        opacityAnimation.values = [self.fromValueForAlpha, 0.8, 0]
        opacityAnimation.keyTimes = [0, self.keyTimeForHalfOpacity, 1]
        opacityAnimation.removedOnCompletion = false
        
        return opacityAnimation
    }
}
