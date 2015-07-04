//
//  VoteDetailsViewController.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VoteDetailsViewController: UIViewController {

    @IBOutlet var addGreenButton : UIButton!
    @IBOutlet var addYellowButton : UIButton!
    @IBOutlet var addRedButton : UIButton!
    
    var colorChart : ColorChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        var screenRect : CGRect = UIScreen.mainScreen().bounds
        
        colorChart = ColorChart(frame: CGRectInset(screenRect,screenRect.size.width/6,screenRect.size.height/2-20))
        
        self.view!.addSubview(colorChart)
    }
    
    @IBAction func addGreenAction()
    {
        var greenColor : ColorChartObject = colorChart.getGreenColor()
        
        greenColor.value += 10
        
        colorChart.reloadChart()
    }
    
    @IBAction func addYellowAction()
    {
        var yellowColor : ColorChartObject = colorChart.getYellowColor()
        
        yellowColor.value += 10
        
        colorChart.reloadChart()
    }
    
    @IBAction func addRedAction()
    {
        var redColor : ColorChartObject = colorChart.getRedColor()
        
        redColor.value += 10
        
        colorChart.reloadChart()
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
