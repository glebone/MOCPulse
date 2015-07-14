//
//  VoteViewController.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VoteViewController : UIViewController {
    private var chart : PieChart!
    var vote : VoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chart = PieChart()
        self.chart.frame = CGRectMake(20, 250, 300, 300)
        self.chart.setup()
        self.view.addSubview(self.chart)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var objPointer = LocalObjectsManager.sharedInstance
        self.vote = objPointer.votes![objPointer.voteIndexSelected!]
        
        randomData()
        drawChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawChart()
    {
        self.chart.ClearChart()
        self.chart.AddChartItem(self.vote!.greenVotes!, color: .VOTE_COLOR_GREEN)
        self.chart.AddChartItem(self.vote!.redVotes!, color: .VOTE_COLOR_RED)
        self.chart.AddChartItem(self.vote!.yellowVotes!, color: .VOTE_COLOR_YELLOW)
        self.chart.DrawChart()
    }
    
    func randomData()
    {
        self.vote?.redVotes = NSInteger(arc4random_uniform(100))
        self.vote?.greenVotes = NSInteger(arc4random_uniform(100))
        self.vote?.yellowVotes = NSInteger(arc4random_uniform(100))
    }
    
    @IBAction func randButtonClicked(sender: AnyObject) {
        randomData()
        drawChart()
    }
}
