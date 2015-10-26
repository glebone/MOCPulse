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
        let image = self.image(color)
        self.setBackgroundImage(image, forState: state)
    }
    
    internal func image(color : UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}




