//
//  ColorChart.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class ColorChart: UIView {

    var redColor : ColorChartObject?
    var yellowColor : ColorChartObject?
    var greenColor : ColorChartObject?
    
    var colorsAray : NSMutableArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func getGreenColor() -> ColorChartObject {
        if (greenColor == nil) {
            greenColor = ColorChartObject()
            greenColor!.value = 33
            greenColor!.color = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
        }
        return greenColor!
    }
    
    func getYellowColor() -> ColorChartObject {
        if (yellowColor == nil) {
            yellowColor = ColorChartObject()
            yellowColor!.value = 33
            yellowColor!.color = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
        }
        return yellowColor!
    }
    
    func getRedColor() -> ColorChartObject {
        if (redColor == nil) {
            redColor = ColorChartObject()
            redColor!.value = 33
            redColor!.color = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        }
        return yellowColor!
    }
    
    func setup() {
        colorsAray = NSMutableArray()
        colorsAray?.addObject(self.getGreenColor())
        colorsAray?.addObject(self.getYellowColor())
        colorsAray?.addObject(self.getRedColor())
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.blackColor()
    }
    
    func clearChart() {
        colorsAray?.removeAllObjects()
        
        self.setNeedsDisplay()
    }
    
    func reloadChart() {
        self.setNeedsDisplay()
    }
    
    func fillRectWithColorOnContext(rect : CGRect, color : CGColorRef, currentGraphicsContext : CGContextRef) {
        CGContextAddRect(currentGraphicsContext, rect);
        CGContextSetFillColorWithColor(currentGraphicsContext, color);
        CGContextFillRect(currentGraphicsContext, rect);
        
    }
    
    override func drawRect(rect: CGRect) {
        var currentGraphicsContext = UIGraphicsGetCurrentContext();
        var sumOfAllSegmentValues : CGFloat = 0.0
        
        for colorObject in [greenColor, yellowColor, redColor]
        {
            sumOfAllSegmentValues += colorObject!.value
        }
        
        var progressRect : CGRect = rect
        
        var lastSegmentRect : CGRect = CGRectMake(0, 0, 0, 0)
        
        for colorObject in [greenColor, yellowColor, redColor]
        {
            var currentSegmentValue : CGFloat = colorObject!.value
            
            var color : CGColorRef = colorObject!.color.CGColor
            
            var percentage : CGFloat = currentSegmentValue / sumOfAllSegmentValues
            
            progressRect = rect
            
            progressRect.size.width *= percentage
            
            progressRect.origin.x    += lastSegmentRect.origin.x + lastSegmentRect.size.width
            
            lastSegmentRect = progressRect;
            
            self.fillRectWithColorOnContext(lastSegmentRect, color: color, currentGraphicsContext: currentGraphicsContext)
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
