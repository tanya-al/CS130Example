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
    let OVERVIEW_VIEW_CARD_HEIGHT: CGFloat = 250
    let BREAKDOWN_VIEW_CARD_HEIGHT: CGFloat = 250
    let TEST_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    
    let VIEW_CARD_LABEL_MARGIN: CGFloat = 15
    
    let PIE_CHART_HEIGHT: CGFloat = 150
    let PIE_CHART_MARGIN: CGFloat = 5
    
    let LINE_CHART_MARGIN: CGFloat = 10
    
    let VIEW_CARD_TITLE_FONT: String = "Avenir"
    
    // MARK: Properties
    var scrollView: UIScrollView?
    var overviewViewCard: UIView?
    var breakdownViewCard: UIView?
    var testViewCard: UIView?
    
    var pieChartColors: [UIColor]
    
    // MARK: Initialization
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        pieChartColors = []
        pieChartColors.append(UIColor(displayP3Red: 219/255, green: 159/255, blue: 86/255, alpha: 100/100))
        pieChartColors.append(UIColor(displayP3Red: 199/255, green: 95/255, blue: 79/255, alpha: 100/100))
        pieChartColors.append(UIColor(displayP3Red: 97/255, green: 152/255, blue: 206/255, alpha: 100/100))
        pieChartColors.append(UIColor(displayP3Red: 105/255, green: 163/255, blue: 109/255, alpha: 100/100))
        pieChartColors.append(UIColor(displayP3Red: 223/255, green: 189/255, blue: 97/255, alpha: 100/100))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Home"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Home")
        view.addSubview(mainNavigationBar)
        
        // initialize scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: mainNavigationBar.frame.height,
                                            width: self.view.frame.width,
                                           height: self.view.frame.height - mainNavigationBar.frame.height))
        scrollView!.backgroundColor = UIColor(displayP3Red: 237/255, green: 237/255, blue: 237/255, alpha: 100/100)
        self.view.addSubview(scrollView!)
        
        // add view cards
        populateOverviewViewCard()
        populateBreakdownViewCard()
        
        testViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                            y: OVERVIEW_VIEW_CARD_HEIGHT + BREAKDOWN_VIEW_CARD_HEIGHT +  VIEW_CARD_MARGIN * 3,
                                        width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                       height: TEST_CHART_VIEW_CARD_HEIGHT))
        testViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(testViewCard!)
        
        
        // update scrollView content height
        scrollView!.contentSize = CGSize(width: scrollView!.contentSize.width,
                                        height: OVERVIEW_VIEW_CARD_HEIGHT + BREAKDOWN_VIEW_CARD_HEIGHT + TEST_CHART_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateBreakdownViewCard() {
        
        // initialize breakdownViewCard
        breakdownViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                                 y: OVERVIEW_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 2,
                                                 width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                                 height: BREAKDOWN_VIEW_CARD_HEIGHT))
        breakdownViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(breakdownViewCard!)
        
        // title
        let title = UILabel(frame: CGRect(x: VIEW_CARD_LABEL_MARGIN, y: VIEW_CARD_LABEL_MARGIN, width: 0, height: 0))
        title.text = "Weekly Breakdown"
        title.textColor = UIColor.black
        title.font = UIFont(name: VIEW_CARD_TITLE_FONT, size: 24)
        title.sizeToFit()
        breakdownViewCard!.addSubview(title)
        
        // line chart
        let lineChartView = LineChartView(frame: CGRect(x: LINE_CHART_MARGIN,
                                                        y: title.frame.height + VIEW_CARD_LABEL_MARGIN,
                                                        width: breakdownViewCard!.frame.width - LINE_CHART_MARGIN * 2,
                                                        height: 200))
        lineChartView.chartDescription?.text = ""
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawLimitLinesBehindDataEnabled = false //?
        //lineChartView.xAxis.drawLabelsEnabled = false
        
//        lineChartView.legend.orientation = Legend.Orientation.vertical
//        lineChartView.legend.horizontalAlignment = Legend.HorizontalAlignment.right
//        lineChartView.legend.verticalAlignment = Legend.VerticalAlignment.center
        
        
        lineChartView.leftAxis.removeAllLimitLines()
        
        let lineChartData = LineChartData()
        let breakdowns = DataManager.sharedInstance.getTempBreakdowns()
        
        for i in 0..<breakdowns.count {
            // iterate through each breakdown
            var lineChartEntries = [ChartDataEntry]()
            for j in 0..<breakdowns[i].amounts.count {
                let dataEntry = ChartDataEntry(x: Double(j), y: breakdowns[i].amounts[j])
                lineChartEntries.append(dataEntry)
            }
            
            let line = LineChartDataSet(values: lineChartEntries, label: breakdowns[i].category)
            line.drawCirclesEnabled = false
            line.colors = [pieChartColors[i]]
            
            lineChartData.addDataSet(line)
        }
//        var lineChartEntries = [ChartDataEntry]()
//        for i in 0..<breakdowns[0].amounts.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: breakdowns[0].amounts[i])
//            lineChartEntries.append(dataEntry)
//        }
//
//        let line1 = LineChartDataSet(values: lineChartEntries, label: breakdowns[0].category)
//        line1.colors = pieChartColors
//
//        let data = LineChartData()
//        data.addDataSet(line1)
        

        lineChartView.data = lineChartData
        breakdownViewCard!.addSubview(lineChartView)
        
        
    }
    
    func populateOverviewViewCard() {
        
        // initialize overviewViewCard
        overviewViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                                y: VIEW_CARD_MARGIN,
                                                width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                                height: OVERVIEW_VIEW_CARD_HEIGHT))
        overviewViewCard!.backgroundColor = UIColor.white
        scrollView!.addSubview(overviewViewCard!)
        
        // title
        let title = UILabel(frame: CGRect(x: VIEW_CARD_LABEL_MARGIN, y: VIEW_CARD_LABEL_MARGIN, width: 0, height: 0))
        title.text = "Overview"
        title.textColor = UIColor.black
        title.font = UIFont(name: VIEW_CARD_TITLE_FONT, size: 24)
        title.sizeToFit()
        overviewViewCard!.addSubview(title)
        
        // pie chart
        // initialize with empty data
        var dataEntries: [PieChartDataEntry] = []
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        // add "%" to label
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter:formatter)
        
        pieChartDataSet.colors = pieChartColors
        pieChartDataSet.sliceSpace = 1
        pieChartDataSet.selectionShift = 5
        
        // initialize pieChartView, negative x position to move chart left
        let pieChartView = PieChartView(frame: CGRect(x: -110,
                                                      y: title.frame.height + VIEW_CARD_LABEL_MARGIN + PIE_CHART_MARGIN,
                                                  width: overviewViewCard!.frame.width + 110,
                                                 height: overviewViewCard!.frame.height - title.frame.height - VIEW_CARD_LABEL_MARGIN - PIE_CHART_MARGIN * 2))
        
        pieChartView.noDataText = "No data available"
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleRadiusPercent = 0.48
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawCenterTextEnabled = false
        pieChartView.chartDescription?.text = ""
        
        // get actual data
        DataManager.sharedInstance.getOverviewsAsync(onSuccess: {overviews in
            for i in 0..<overviews.count {
                let dataEntry = PieChartDataEntry(value: overviews[i].percentage, label: overviews[i].category)
                dataEntries.append(dataEntry)
            }
            
            pieChartDataSet.values = dataEntries
            
            DispatchQueue.main.async {
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartView.notifyDataSetChanged()
                
                // customize legend
                pieChartView.legend.orientation = Legend.Orientation.vertical
                pieChartView.legend.xOffset = 350
                pieChartView.legend.yOffset = 110
            }
        }, onFailure: {error in
    
        })

        overviewViewCard!.addSubview(pieChartView)
    }
    
}
