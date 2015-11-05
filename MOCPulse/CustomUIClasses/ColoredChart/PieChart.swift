//
//  PieChart.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import VBPieChart
import SwiftyJSON

class PieChart : VBPieChart {
    var chartArray : [ChartItem] = [];
    
    class ChartItem {
        var name: String
        var chartColor: VoteColor
        var value: Int
        
        init(color_: VoteColor, value_: Int) {
            self.name = "unk"
            self.chartColor = color_
            self.value = value_
        }
        
        func toDictionary() -> [String:NSObject]
        {
            return ["name": "unk", "value":self.value, "color":self.chartColor.forPieChart]
        }
    }
    
    func setup() {
        self.enableStrokeColor = true
        self.holeRadiusPrecent = 0.3
        
        self.layer.shadowOffset = CGSizeMake(2, 2)
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.7
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DrawChartWithJSON(data: NSData)
    {
        var json = JSON(data: data);
        
        let yCount = json["yellow"].intValue;
        let gCount = json["green"].intValue;
        let rCount = json["red"].intValue;
        
        ClearChart();
        AddChartItem(yCount, color: .VOTE_COLOR_YELLOW);
        AddChartItem(gCount, color: .VOTE_COLOR_GREEN);
        AddChartItem(rCount, color: .VOTE_COLOR_RED);
        DrawChart();
    }
    
    func ClearChart()
    {
        self.chartArray.removeAll(keepCapacity: false);
    }
    
    func AddChartItem(value: NSInteger, color: VoteColor)
    {
        if value == 0 {
            return;
        }
        
        let item = ChartItem(color_: color, value_: value);
        self.chartArray.append(item)
    }
    
    func DrawChart()
    {
        var localItemArray = [ [String:NSObject] ]();
        for i in self.chartArray {
            localItemArray.append(i.toDictionary());
        }
        
        self.setChartValues(localItemArray, animation:true);
    }
}
