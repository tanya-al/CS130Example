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
    let TRANSACTION_DATA_NOTIFICATION = "transactionDataNotification"
    let CELL_HEIGHT: CGFloat = 85
    let NUMBER_OF_ROW_FIRST_SECTION = 3
    
    // MARK: Properties
    var tableView: UITableView!
    var transactions: [Transaction]?
    
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
    }
    
    func getTransactionData() {
        print("[ReceiptsVC][getReceiptData] Getting transactions data...")
        DataManager.sharedInstance.getTransactionsAsync(onSuccess: { (transactions) in
            self.transactions = transactions
            NotificationCenter.default.post(name: Notification.Name(self.TRANSACTION_DATA_NOTIFICATION), object: nil)
        }, onFailure: { (error) in
            print("[TransactionsVC][getTransactionData] Error")
        })
    }
    
    @objc func transactionDataReceived() {
        print("[ReceiptsVC][receiptDataReceived] Called")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions == nil {
            return 0
        } else if section == 0 {
            return min(NUMBER_OF_ROW_FIRST_SECTION, transactions!.count)
        } else {
            return max(transactions!.count - NUMBER_OF_ROW_FIRST_SECTION, 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactions != nil {
            let cell = TransactionTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_ID, transaction: transactions![indexPath.row])
            return cell
        }
        
        return TransactionTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_ID)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if transactions == nil || transactions!.count <= NUMBER_OF_ROW_FIRST_SECTION {
            return 1
        } else {
            return 2
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
