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
    
    static let DUMMY_USER_ID: Int = 42069
    static let DUMMY_NUMBER_OF_WEEKS: Int = 5
    
    let AMOUNT_JSON_KEY: String = "amount"
    let CATEGORY_JSON_KEY: String = "category"
    let PERCENTAGE_JSON_KEY: String = "percentage"
    
    private var _transactions: [Transaction]?
    private var _overviews: [Overview]?
    private var _breakdowns: [Breakdown]?
    
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
    
    func getTempBreakdowns() -> [Breakdown] {
        if (_breakdowns == nil) {
            _breakdowns = []
            _breakdowns?.append(Breakdown(category: "Restaurant", amounts: [50, 20, 40, 60])!)
            _breakdowns?.append(Breakdown(category: "Transportation", amounts: [15, 22, 19, 44])!)
            _breakdowns?.append(Breakdown(category: "Textbook", amounts: [70, 20, 0, 0])!)
            _breakdowns?.append(Breakdown(category: "Grocery", amounts: [42, 27, 55, 39])!)
            _breakdowns?.append(Breakdown(category: "Other", amounts: [19, 23, 43, 26])!)
        }
        
        return _breakdowns!
    }
    
    func getOverviewsAsync(onSuccess: @escaping([Overview]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getOverviewWithUserIdAndNumberOfWeeks(userId: DataManager.DUMMY_USER_ID,
                                                                     numberOfWeeks: DataManager.DUMMY_NUMBER_OF_WEEKS,
                                                                         onSuccess:
        { json in
            print("[DataManager] getOverviewsAsync success! Parsing JSON...")
            self._overviews = []
                                                                    
            // parse JSON
            for item in json.array! {
                let amount = item[self.AMOUNT_JSON_KEY].double
                let category = item[self.CATEGORY_JSON_KEY].string
                let percentage = item[self.PERCENTAGE_JSON_KEY].double
                self._overviews?.append(Overview(category: category!, amount: amount!, percentage: percentage!)!)
            }

            onSuccess(self._overviews!)
        }, onFailure: { error in
            print("[DataManager][Error] getOverviewsAsync")
            onFailure(error)
        })
    }
    
    func getTransactionsAsync(onSuccess: @escaping([Overview]) -> Void, onFailure: @escaping(Error) -> Void) {
        print("getTransactionsAsync not implemented yet!!")
        abort()
    }
    
}
