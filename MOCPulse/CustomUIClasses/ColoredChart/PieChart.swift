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

enum ChartColors {
    case CHART_COLOR_GREEN
    case CHART_COLOR_RED
    case CHART_COLOR_YELLOW

    
    var description : String {
        switch self {
        case .CHART_COLOR_GREEN: return "CHART_COLOR_GREEN";
        case .CHART_COLOR_RED: return "CHART_COLOR_RED";
        case .CHART_COLOR_YELLOW: return "CHART_COLOR_YELLOW";
        }
    }
    
    var color : UIColor {
        switch self {
        case .CHART_COLOR_GREEN: return UIColor(hexString: "00bf20");
        case .CHART_COLOR_RED: return UIColor(hexString: "fb250d");
        case .CHART_COLOR_YELLOW: return UIColor(hexString: "ffc000");
        }
    }
}

class PieChart : VBPieChart {
    var chartArray : [ChartItem] = [];
    
    class ChartItem {
        var name: String
        var chartColor: ChartColors        
        var value: Int
        
        init(color_: ChartColors, value_: Int) {
            self.name = "unk"
            self.chartColor = color_
            self.value = value_
        }
        
        func toDictionary() -> [String:NSObject]
        {
            return ["name": "unk", "value":self.value, "color":self.chartColor.color]
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
    
    func AddChartItem(value: NSInteger, color: ChartColors)
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
            localItemArray.append(i.toDictionary());
        }
        
        self.setChartValues(localItemArray, animation:true);
    }
}
