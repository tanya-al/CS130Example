//
//  OverviewViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit
import Charts

class OverviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Overview"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Overview")
        view.addSubview(mainNavigationBar)
        
        setOverviewPieChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOverviewPieChart() {
        
        let pieChartView = PieChartView(frame: self.view.frame)
        let overviews = DataManager.sharedInstance.getOverviews()
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<overviews.count {
            let dataEntry = PieChartDataEntry(value: overviews[i].percentage, label: overviews[i].category)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Overview")
        
        var colors: [UIColor] = []
        for _ in 0..<overviews.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        pieChartView.data = PieChartData(dataSet: pieChartDataSet)
        pieChartView.noDataText = "No data available"
        
        let d = Description()
        d.text = "iOSCharts.io"
        pieChartView.chartDescription = d
        pieChartView.centerText = "Pie Chart"
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleColor = UIColor.clear
        self.view.addSubview(pieChartView)
    }
    
}
