//
//  SettingsViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

/// SettingsViewController: display user settings
class SettingsViewController: UIViewController {
    
    /// viewDidLoad()
    /// - Description: show settings
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Settings"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Settings")
        view.addSubview(mainNavigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
