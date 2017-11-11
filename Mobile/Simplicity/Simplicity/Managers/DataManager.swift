//
//  DataManager.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/10/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    private var _transactions: [Transaction]?
    private var _overviews: [Overview]?
    
    private override init() {
        super.init()
    }
    
    func getTransactions() -> [Transaction] {
        if (_transactions == nil) {
            // TODO: get transactions from RequestManager
            _transactions = []
            _transactions?.append(Transaction(transactionId: 1, userId: 1, category: "test", amount: 5.00, date: NSDate())!)
            _transactions?.append(Transaction(transactionId: 2, userId: 1, category: "test", amount: 9.00, date: NSDate())!)
        }
        
        return _transactions!
    }
    
    func getOverviews() -> [Overview] {
        if (_overviews == nil) {
            // TODO: get overviews from RequestManager
            _overviews = []
            _overviews?.append(Overview(category: "category 1", amount: 30, percentage: 60)!)
            _overviews?.append(Overview(category: "category 1", amount: 20, percentage: 40)!)
        }
        
        return _overviews!
    }
    
}
