//
//  VoteViewController.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VoteViewController : UIViewController {
    var chart = SimpleChart()
    var vote : VoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(chart.chartView)
        
        UpdateChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DrawChart()
    {
        chart.ClearChart()
        chart.AddChartItem(self.vote!.greenVotes!, color: ChartColors.CHART_COLOR_GREEN)
        chart.AddChartItem(self.vote!.redVotes!, color: ChartColors.CHART_COLOR_RED)
        chart.AddChartItem(self.vote!.yellowVotes!, color: ChartColors.CHART_COLOR_YELLOW)
        chart.DrawChart()
    }
    
    func UpdateChart()
    {
        var objPointer = LocalObjectsManager.sharedInstance
        self.vote = objPointer.votes[objPointer.voteIndexSelected!] as? VoteModel
        DrawChart()
    }
    
    @IBAction func randButtonClicked(sender: AnyObject) {
        self.vote?.redVotes = NSInteger(arc4random_uniform(100))
        self.vote?.greenVotes = NSInteger(arc4random_uniform(100))
        self.vote?.yellowVotes = NSInteger(arc4random_uniform(100))
        UpdateChart()
    }
}
