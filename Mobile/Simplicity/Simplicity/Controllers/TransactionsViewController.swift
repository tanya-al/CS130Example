//
//  TransactionsViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_ID = "CELL_ID"
    
    // MARK: Properties
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Transactions"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Transactions")
        view.addSubview(mainNavigationBar)
        
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: mainNavigationBar.frame.height,
                                          width: view.frame.width,
                                         height: view.frame.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        view.addSubview(tableView)
        
        // TODO: height sizing issue for TableView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_ID)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
