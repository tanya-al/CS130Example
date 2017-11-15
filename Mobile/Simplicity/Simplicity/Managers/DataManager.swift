//
//  DataManager.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/10/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    static let DUMMY_USER_ID: Int = 1
    //private var _userId: Int
    
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
            _overviews?.append(Overview(category: "Restaurant", amount: 60, percentage: 30)!)
            _overviews?.append(Overview(category: "Transportation", amount: 40, percentage: 20)!)
            _overviews?.append(Overview(category: "Textbook", amount: 30, percentage: 15)!)
            _overviews?.append(Overview(category: "Grocery", amount: 40, percentage: 20)!)
            _overviews?.append(Overview(category: "Other", amount: 30, percentage: 15)!)
        }
        
        return _overviews!
    }
    
    func getOverviewsAsync(onSuccess: @escaping([Overview]) -> Void, onFailure: @escaping(Error) -> Void) {
        
    }
    
    func getTransactionsAsync(onSuccess: @escaping([Overview]) -> Void, onFailure: @escaping(Error) -> Void) {
        print("hello")
        
        
        RequestManager.sharedInstance.getTransactionsWithUserId(userId: DataManager.DUMMY_USER_ID, onSuccess: { json in
            print(json)
            
            // parse JSON
            
        }, onFailure: { error in
            print("rip yo")
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            //self.show(alert, sender: nil)
        })
    }
    
}
