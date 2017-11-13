//
//  TabBarController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add View Controllers to Tab Bar
        let overviewViewController = OverviewViewController()
        overviewViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "./../SupportFiles/Assets.xcassets/tabbaritems.imageset/home"), tag: 1)
        
        let transactionsViewController = TransactionsViewController()
        transactionsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        transactionsViewController.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(named: "./../SupportFiles/Assets.xcassets/tabbaritems.imageset/transactions"), tag: 1)
        
        let addViewController = AddViewController()
        addViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        addViewController.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "./../SupportFiles/Assets.xcassets/tabbaritems.imageset/add"), tag: 1)
        
        let receiptsViewController = ReceiptsViewController()
        receiptsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
        receiptsViewController.tabBarItem = UITabBarItem(title: "Receipts", image: UIImage(named: "./../SupportFiles/Assets.xcassets/tabbaritems.imageset/receipts"), tag: 1)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 4)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "./../SupportFiles/Assets.xcassets/tabbaritems.imageset/settings"), tag: 1)
        
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
