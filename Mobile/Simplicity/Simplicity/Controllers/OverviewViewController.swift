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
    let LINE_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    let TEST_CHART_VIEW_CARD_HEIGHT: CGFloat = 250
    
    let VIEW_CARD_LABEL_MARGIN: CGFloat = 15
    
    let PIE_CHART_HEIGHT: CGFloat = 150
    let PIE_CHART_MARGIN: CGFloat = 5
    
    // MARK: Properties
    var scrollView: UIScrollView?
    var overviewViewCard: UIView?
    var lineChartViewCard: UIView?
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
        
        lineChartViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                                 y: OVERVIEW_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 2,
                                             width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                            height: LINE_CHART_VIEW_CARD_HEIGHT))
        lineChartViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(lineChartViewCard!)
        
        testViewCard = UIView(frame: CGRect(x: VIEW_CARD_MARGIN,
                                            y: OVERVIEW_VIEW_CARD_HEIGHT + LINE_CHART_VIEW_CARD_HEIGHT +  VIEW_CARD_MARGIN * 3,
                                        width: scrollView!.frame.width - VIEW_CARD_MARGIN * 2,
                                       height: TEST_CHART_VIEW_CARD_HEIGHT))
        testViewCard!.backgroundColor = UIColor.white
        scrollView?.addSubview(testViewCard!)
        
        
        // update scrollView content height
        scrollView!.contentSize = CGSize(width: scrollView!.contentSize.width,
                                        height: OVERVIEW_VIEW_CARD_HEIGHT + LINE_CHART_VIEW_CARD_HEIGHT + TEST_CHART_VIEW_CARD_HEIGHT + VIEW_CARD_MARGIN * 4)
        
        
        DataManager.sharedInstance.getOverviewsAsync(onSuccess: { _ in }, onFailure: { _ in })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        title.font = UIFont(name: "Avenir", size: 24)
        title.sizeToFit()
        overviewViewCard!.addSubview(title)
        
        // pie chart
//        let overviews = DataManager.sharedInstance.getOverviews()
//        var dataEntries: [PieChartDataEntry] = []
//
//        for i in 0..<overviews.count {
//            let dataEntry = PieChartDataEntry(value: overviews[i].percentage, label: overviews[i].category)
//            dataEntries.append(dataEntry)
//        }
        
        //let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        let pieChartDataSet = PieChartDataSet()
        //pieChartDataSet.values = dataEntries
        
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
        
        //pieChartView.data = PieChartData(dataSet: pieChartDataSet)
        pieChartView.noDataText = "No data available"
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleRadiusPercent = 0.48
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawCenterTextEnabled = false
        pieChartView.chartDescription?.text = ""
        
        DataManager.sharedInstance.getOverviewsAsync(onSuccess: {overviews in
            var dataEntries: [PieChartDataEntry] = []
            
            for i in 0..<overviews.count {
                let dataEntry = PieChartDataEntry(value: overviews[i].percentage, label: overviews[i].category)
                dataEntries.append(dataEntry)
            }
            
            pieChartDataSet.values = dataEntries
            
            DispatchQueue.main.async {
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartView.notifyDataSetChanged()
                
                pieChartView.noDataText = "No data available"
                pieChartView.holeRadiusPercent = 0.4
                pieChartView.transparentCircleRadiusPercent = 0.48
                pieChartView.drawEntryLabelsEnabled = false
                pieChartView.drawCenterTextEnabled = false
                pieChartView.chartDescription?.text = ""
                pieChartView.legend.orientation = Legend.Orientation.vertical
                pieChartView.legend.xOffset = 350
                pieChartView.legend.yOffset = 110
            }
        }, onFailure: {error in
    
        })
        
        // customize legend
//        pieChartView.legend.orientation = Legend.Orientation.vertical
//        pieChartView.legend.xOffset = 350
//        pieChartView.legend.yOffset = 110

        overviewViewCard!.addSubview(pieChartView)
    }
    
}
