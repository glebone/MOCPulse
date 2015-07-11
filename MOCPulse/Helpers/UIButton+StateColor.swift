//
//  UIButton+StateColor.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 10.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setColorState(color : UIColor, state : UIControlState) {
        var image = self.image(color)
        self.setBackgroundImage(image, forState: state)
    }
    
    internal func image(color : UIColor) -> UIImage {
        var rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect);
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}




