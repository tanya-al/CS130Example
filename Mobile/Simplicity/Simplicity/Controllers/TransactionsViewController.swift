//
//  TransactionsViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

/// TransactionViewController: displays a list of user transactions
class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_ID = "CELL_ID"
    let TRANSACTION_DATA_NOTIFICATION = "transactionDataNotification"
    let CELL_HEIGHT: CGFloat = 85
    let NUMBER_OF_ROW_FIRST_SECTION = 3
    
    // MARK: Properties
    var tableView: UITableView!
    var transactions: [Transaction]?
    
    /// viewDidLoad
    /// - Description: display transaction data in a list
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
                                         height: view.frame.height - mainNavigationBar.frame.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: CELL_ID)
        view.addSubview(tableView)
        // TODO: height sizing issue for TableView
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TransactionsViewController.transactionDataReceived),
                                               name: Notification.Name(TRANSACTION_DATA_NOTIFICATION) ,
                                               object: nil)
        getTransactionData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTransactionData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    /// getTransactionData
    /// - Description: Query transaction data from backend
    func getTransactionData() {
        print("[TransactionsVC][getTransactionData] Getting transactions data...")
        DataManager.sharedInstance.getTransactionsAsync(onSuccess: { (transactions) in
            self.transactions = transactions
            NotificationCenter.default.post(name: Notification.Name(self.TRANSACTION_DATA_NOTIFICATION), object: nil)
        }, onFailure: { (error) in
            print("[TransactionsVC][getTransactionData] Error")
        })
    }
    
    /// transactionDataReceived
    /// - Description: reload data when received from backend
    @objc func transactionDataReceived() {
        print("[TransactionsVC][getTransactionData] Called")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// refreshTransactionData
    ///
    /// - Description: calls reloadData() and the DataManager
    ///
    /// - Parameter sender: refresh when the user clicks the tab
    @objc private func refreshTransactionData(_ sender: Any) {
        print("[TransactionsVC][refreshTransactionData]")
        DataManager.sharedInstance.getTransactionsAsync(onSuccess: { (transactions) in
            print("[TransactionsVC][refreshTransactionData] Success!")
            self.transactions = transactions
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
            
        }, onFailure: { (error) in
            print("[TransactionsVC][refreshTransactionData] Error")
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UITableViewDataSource
    
    /// tableView
    ///
    /// - Description: set number of rows in table
    ///
    /// - Parameters:
    ///   - tableView: this screens table view
    ///   - section: the number of rows we want
    /// - Returns: number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions == nil {
            return 0
        } else if section == 0 {
            return min(NUMBER_OF_ROW_FIRST_SECTION, transactions!.count)
        } else {
            return max(transactions!.count - NUMBER_OF_ROW_FIRST_SECTION, 0)
        }
    }
    
    /// tableView
    ///
    /// - Description: return the cell at a specified row index
    ///
    /// - Parameters:
    ///   - tableView: our table view
    ///   - indexPath: the index we want
    /// - Returns: return the cell at index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactions != nil {
            let cell = TransactionTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_ID, transaction: transactions![indexPath.row])
            return cell
        }
        
        return TransactionTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_ID)
    }
    
    /// numberOfSections
    ///
    /// - Parameter tableView: this screen's table view
    /// - Returns: returns the number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        if transactions == nil || transactions!.count <= NUMBER_OF_ROW_FIRST_SECTION {
            return 1
        } else {
            return 2
        }
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: this screen's table view
    ///   - section: the section number
    /// - Returns: return title of given section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if transactions == nil {
            return nil
        } else if section == 0 {
            return "Recent transactions"
        } else {
            return "All transactions"
        }
    }
    
    // MARK: UITableViewDelegate
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: this screen's table view
    ///   - indexPath: the index
    /// - Returns: cell height at that index
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
