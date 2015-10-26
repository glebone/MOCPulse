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
    
    var redLabel : UILabel?
    var yellowLabel : UILabel?
    var greenLabel : UILabel?
    
    var colorsAray : NSMutableArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func getGreenColor() -> ColorChartObject {
        if (greenColor == nil) {
            greenColor = ColorChartObject()
            greenColor!.value = 33
            greenColor!.color = UIColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1)
        }
        return greenColor!
    }
    
    func getYellowColor() -> ColorChartObject {
        if (yellowColor == nil) {
            yellowColor = ColorChartObject()
            yellowColor!.value = 33
            yellowColor!.color = UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1)
        }
        return yellowColor!
    }
    
    func getRedColor() -> ColorChartObject {
        if (redColor == nil) {
            redColor = ColorChartObject()
            redColor!.value = 33
            redColor!.color = UIColor(red: 221/255, green: 48/255, blue: 61/255, alpha: 1)
        }
        return redColor!
    }
    
    func getGreenLabel() -> UILabel {
        if (greenLabel == nil) {
            greenLabel = UILabel()
            greenLabel?.minimumScaleFactor = 0.5
            greenLabel?.textAlignment = NSTextAlignment.Center
            greenLabel?.textColor = UIColor.whiteColor()
            self.addSubview(greenLabel!)
        }
        return greenLabel!
    }
    
    func getYellowLabel() -> UILabel {
        if (yellowLabel == nil) {
            yellowLabel = UILabel()
            yellowLabel?.minimumScaleFactor = 0.5
            yellowLabel?.textAlignment = NSTextAlignment.Center
            yellowLabel?.textColor = UIColor.whiteColor()
            self.addSubview(yellowLabel!)
        }
        return yellowLabel!
    }
    
    func getRedLabel() -> UILabel {
        if (redLabel == nil) {
            redLabel = UILabel()
            redLabel?.minimumScaleFactor = 0.5
            redLabel?.textAlignment = NSTextAlignment.Center
            redLabel?.textColor = UIColor.whiteColor()
            self.addSubview(redLabel!)
        }
        return redLabel!
    }
    
    func setup() {
        colorsAray = NSMutableArray()
        colorsAray?.addObject(self.getGreenColor())
        colorsAray?.addObject(self.getYellowColor())
        colorsAray?.addObject(self.getRedColor())
        
        self.layer.cornerRadius = 5
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
        if (greenColor == nil || redColor == nil || yellowColor == nil) {
            return
        }
        
        let currentGraphicsContext = UIGraphicsGetCurrentContext();
        var sumOfAllSegmentValues : CGFloat = 0.0
        
        for colorObject in [greenColor, yellowColor, redColor]
        {
            sumOfAllSegmentValues += colorObject!.value
        }
        
        var progressRect : CGRect = rect
        
        var lastSegmentRect : CGRect = CGRectMake(0, 0, 0, 0)
        
        for colorObject in [greenColor, yellowColor, redColor]
        {
            let currentSegmentValue : CGFloat = colorObject!.value
            
            let color : CGColorRef = colorObject!.color.CGColor
            
            let percentage : CGFloat = currentSegmentValue / sumOfAllSegmentValues
            
            progressRect = rect
            
            progressRect.size.width *= percentage
            
            progressRect.origin.x += lastSegmentRect.origin.x + lastSegmentRect.size.width
            
            lastSegmentRect = progressRect;
            
            self.fillRectWithColorOnContext(lastSegmentRect, color: color, currentGraphicsContext: currentGraphicsContext!)
            
            var label = UILabel()
            
            if (colorObject == greenColor) {
                label = self.getGreenLabel()
            }
            else if (colorObject == yellowColor) {
                label = self.getYellowLabel()
            }
            else if (colorObject == redColor) {
                label = self.getRedLabel()
            }
            
            label.frame = lastSegmentRect
            label.text = NSString(format: "%.0f", colorObject!.value) as String
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
