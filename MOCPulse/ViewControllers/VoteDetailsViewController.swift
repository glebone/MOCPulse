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

    @IBOutlet var addGreenButton : UIButton!
    @IBOutlet var addYellowButton : UIButton!
    @IBOutlet var addRedButton : UIButton!
    
    var colorChart : ColorChart!
    
    var pulseEffect : PulseAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        var screenRect : CGRect = UIScreen.mainScreen().bounds
        
        colorChart = ColorChart(frame: CGRectMake(7, 100, screenRect.size.width - 14, 70))
        self.view!.addSubview(colorChart)
        
        pulseEffect = PulseAnimation(radius: screenRect.size.width * 2, position: CGPointMake(self.view.center.x, self.view.center.y - self.navigationController!.navigationBar.frame.size.height))
    }
    
    @IBAction func addGreenAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        var greenColor : ColorChartObject = colorChart.getGreenColor()
        
        greenColor.value += 10
        
        colorChart.reloadChart()
        
        showPulseAnimation(greenColor.color)
    }
    
    @IBAction func addYellowAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        var yellowColor : ColorChartObject = colorChart.getYellowColor()
        
        yellowColor.value += 10
        
        colorChart.reloadChart()
        
        showPulseAnimation(yellowColor.color)
    }
    
    @IBAction func addRedAction()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        var redColor : ColorChartObject = colorChart.getRedColor()
        
        redColor.value += 10
        
        colorChart.reloadChart()
        
        showPulseAnimation(redColor.color)
    }
    
    func showPulseAnimation(color : UIColor) {
        if (pulseEffect.superlayer == nil) {
            view.layer.insertSublayer(pulseEffect, below: colorChart.layer)
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
