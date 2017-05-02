//
//  StatisticsUtility.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/4/2.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import Charts

class StatisticsUtility {
    
    class func setBarData(barView: BarChartView, xLabels: [String], values: [Double], title: String) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0 ..< values.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 1), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: title)
        chartDataSet.colors = [TipCalcDataManager.widgetTintColor()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        barView.data = chartData
        barView.animate(xAxisDuration: 1.3, yAxisDuration: 1.2)
    }
    
    class func setLineData(lineView: LineChartView, values: [Double], label: String) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< values.count {
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(values: dataEntries, label: label)
        lineDataSet.colors = [TipCalcDataManager.widgetTintColor()]
        lineDataSet.circleColors = [TipCalcDataManager.widgetTintColor()]
        let lineData = LineChartData(dataSets: [lineDataSet])
        
        lineView.data = lineData
        lineView.animate(yAxisDuration: 1.2)
    }
    
    class func setPieData(pieView: PieChartView, labels: [String], values: [Double]) {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0 ..< labels.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: labels[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor.flatRed, UIColor.flatYellow, UIColor.flatGreen, UIColor.flatSkyBlue, UIColor.flatMagenta, UIColor.flatPink]
        let chartData = PieChartData(dataSets: [chartDataSet])
        
        pieView.data = chartData
        pieView.animate(xAxisDuration: 1.3, yAxisDuration: 1.2)
    }

}
