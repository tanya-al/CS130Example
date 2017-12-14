//
//  TabBarController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

/// TabBarController: instantiates the tabs of the app
class TabBarController: UITabBarController {
    
    /// viewDidLoad
    /// - Description: initializes the various tabs for the user
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add View Controllers to Tab Bar
        let overviewViewController = OverviewViewController()
        overviewViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 1)
        
        let transactionsViewController = TransactionsViewController()
        transactionsViewController.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(named: "transactions"), tag: 2)
        
        let addViewController = AddViewController()
        addViewController.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "add"), tag: 3)
        
        let layout = UICollectionViewFlowLayout()
        let receiptsViewController = ReceiptsViewController(collectionViewLayout: layout)
        receiptsViewController.tabBarItem = UITabBarItem(title: "Receipts", image: UIImage(named: "receipts"), tag: 4)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 5)
        
        let viewControllerList = [ overviewViewController,
                                   transactionsViewController,
                                   addViewController,
                                   receiptsViewController,
                                   settingsViewController ] as [Any]
        
        viewControllers = viewControllerList as? [UIViewController]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
