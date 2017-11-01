//
//  ReceiptsViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipts"
        
        let dummyLabel = UILabel()
        dummyLabel.text = "Receipts"
        dummyLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        dummyLabel.textAlignment = .center
        dummyLabel.font=UIFont.systemFont(ofSize: 22)
        view.addSubview(dummyLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
