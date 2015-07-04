//
//  SimpleChart.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import VBPieChart
import SwiftyJSON

enum ChartColors {
    case CHART_COLOR_GREEN
    case CHART_COLOR_RED
    case CHART_COLOR_YELLOW
}

class SimpleChart /*: VBPieChart */{
    var chartView = VBPieChart();
    var chartArray : [ChartItem] = [];
    
    class ChartItem {
        var color: ChartColors;
        var value: Int;
        
        init(color_: ChartColors, value_: Int) {
            self.color = color_;
            self.value = value_;
        }
        
        func GenerateArray() -> [String:NSObject]
        {
            var colorFromHex : UIColor;
            
            switch self.color {
            case ChartColors.CHART_COLOR_GREEN:
                colorFromHex = UIColor(hexString: "00bf20");
            case ChartColors.CHART_COLOR_RED:
                colorFromHex = UIColor(hexString: "fb250d");
            case ChartColors.CHART_COLOR_YELLOW:
                colorFromHex = UIColor(hexString: "ffc000");
            }
            
            var result = ["name": "unk", "value":self.value, "color":colorFromHex];
            
            return result;
        }
    }
    
    init() {
        //super.init();
        
        chartView.frame = CGRectMake(20, 250, 300, 300);
        chartView.enableStrokeColor = true;
        chartView.holeRadiusPrecent = 0.3;
        
        chartView.layer.shadowOffset = CGSizeMake(2, 2);
        chartView.layer.shadowRadius = 3;
        chartView.layer.shadowColor = UIColor.blackColor().CGColor;
        chartView.layer.shadowOpacity = 0.7;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DrawChartWithJSON(data: NSData)
    {
        var json = JSON(data: data);
        
        var yCount = json["yellow"].intValue;
        var gCount = json["green"].intValue;
        var rCount = json["red"].intValue;
        
        ClearChart();
        AddChartItem(yCount, color: ChartColors.CHART_COLOR_YELLOW);
        AddChartItem(gCount, color: ChartColors.CHART_COLOR_GREEN);
        AddChartItem(rCount, color: ChartColors.CHART_COLOR_RED);
        DrawChart();
    }
    
    func ClearChart()
    {
        self.chartArray.removeAll(keepCapacity: false);
    }
    
    func AddChartItem(value: Int, color: ChartColors)
    {
        if value == 0 {
            return;
        }
        
        var item = ChartItem(color_: color, value_: value);
        self.chartArray.append(item)
    }
    
    func DrawChart()
    {
        var localItemArray = [ [String:NSObject] ]();
        for i in self.chartArray {
            localItemArray.append(i.GenerateArray());
        }
        
        chartView.setChartValues(localItemArray, animation:true);
    }
}
