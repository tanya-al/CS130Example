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
    
    let VIEW_CARD_MARGIN: CGFloat = 10
    let PIE_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    let LINE_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    let TEST_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    
    // MARK: Properties
    var scrollView: UIScrollView?
    var pieChartViewCard: UIView?
    var lineChartViewCard: UIView?
    var testViewCard: UIView?
    
    // MARK: Initialization
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Overview"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Overview")
        view.addSubview(mainNavigationBar)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: mainNavigationBar.frame.height,
                                            width: self.view.frame.width,
                                           height: self.view.frame.height - mainNavigationBar.frame.height))
        scrollView!.backgroundColor = UIColor(displayP3Red: 237/255, green: 237/255, blue: 237/255, alpha: 100/100)
        self.view.addSubview(scrollView!)
        
        pieChartViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                                y: VIEW_CARD_MARGIN,
                                            width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                           height: PIE_CHART_VIEW_CARD_HEIGHT))
        pieChartViewCard!.backgroundColor = UIColor.white
        scrollView!.addSubview(pieChartViewCard!)
        
        lineChartViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                                 y: PIE_CHART_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 2,
                                             width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                            height: LINE_CHART_VIEW_CARD_HEIGHT))
        lineChartViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(lineChartViewCard!)
        
        testViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                            y: PIE_CHART_VIEW_CARD_HEIGHT + LINE_CHART_VIEW_CARD_HEIGHT +  VIEW_CARD_MARGIN * 3,
                                        width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                       height: TEST_CHART_VIEW_CARD_HEIGHT))
        testViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(testViewCard!)
        
        
        // update scrollView content height
        scrollView!.contentSize = CGSize(width: scrollView!.contentSize.width,
                                        height: PIE_CHART_VIEW_CARD_HEIGHT + LINE_CHART_VIEW_CARD_HEIGHT + TEST_CHART_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 4)
        
        //setOverviewPieChart()
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
