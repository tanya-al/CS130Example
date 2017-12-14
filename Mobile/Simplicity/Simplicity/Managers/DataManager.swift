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
    static let DUMMY_USER_ID2: Int = 5318008
    static let DUMMY_NUMBER_OF_WEEKS: Int = 5
    
    let AMOUNT_JSON_KEY: String = "amount"
    let AMOUNTS_JSON_KEY: String = "amounts"
    let CATEGORY_JSON_KEY: String = "category"
    let DESCRIPTION_JSON_KEY: String = "description"
    let PERCENTAGE_JSON_KEY: String = "percentage"
    let BREAKDOWNS_JSON_KEY: String = "breakdowns"
    let DATE_JSON_KEY: String = "date"
    let THUMBNAIL_IMAGE_DATA_JSON_KEY: String = "thumbnailImageData"
    let TRANSACTION_ID_JSON_KEY: String = "transactionId"
    let USER_ID_JSON_KEY: String = "userId"
    let IMAGE_JSON_KEY: String = "img"
    let IMAGE_DATA_JSON_KEY: String = "data"
    
    let DATE_FORMATTER = "yyyy-MM-dd HH:mm:ss"
    
    private var _transactions: [Transaction]?
    private var _overviews: [Overview]?
    private var _breakdowns: [Breakdown]?
    private var _receipts: [Receipt]?
    private var _receiptTransactions: [ReceiptTransactionAmount]?
    
    private override init() {
        super.init()
    }
    
    func getTransactions() -> [Transaction] {
        if (_transactions == nil) {
            // TODO: get transactions from RequestManager
            _transactions = []
            //_transactions?.append(Transaction(transactionId: 1, userId: 1, category: "test", amount: 5.00, date: NSDate())!)
            //_transactions?.append(Transaction(transactionId: 2, userId: 1, category: "test", amount: 9.00, date: NSDate())!)
        }
        
        return _transactions!
    }
    
    /// @brief: getOverviews: returns overview info for the user
    ///
    /// @return: [Overview]
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
            _breakdowns?.append(Breakdown(category: "Restaurant", amounts: [50, 20, 40, 60, 45])!)
            _breakdowns?.append(Breakdown(category: "Transportation", amounts: [15, 52, 19, 44, 33])!)
            _breakdowns?.append(Breakdown(category: "Textbook", amounts: [70, 30, 10, 10, 10])!)
            _breakdowns?.append(Breakdown(category: "Grocery", amounts: [42, 37, 55, 39, 44])!)
            _breakdowns?.append(Breakdown(category: "Other", amounts: [19, 23, 43, 26, 33])!)
        }
        
        return _breakdowns!
    }
    
    /// getOverviewsAsync: asynchronously queries the backend for the user's overview data and parses the result
    ///
    /// - Parameters:
    ///   - onSuccess: returns list of Overview data [Overview]
    ///   - onFailure: returns Error
    func getOverviewsAsync(onSuccess: @escaping([Overview]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getOverviewWithUserIdAndNumberOfWeeks(userId: DataManager.DUMMY_USER_ID,
                                                                     numberOfWeeks: DataManager.DUMMY_NUMBER_OF_WEEKS,
                                                                         onSuccess:
        { json in
            print("[DataManager] getOverviewsAsync success! Parsing JSON...")
            self._overviews = []
            print(json)
            print(json.array)
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
    
    /// getBreakdownsAsync: asynchronously queries the backend for the user's breakdown data  and parses the result
    ///
    /// - Parameters:
    ///   - onSuccess: returns array of Breakdowns [Breakdown]
    ///   - onFailure: returns Error
    func getBreakdownsAsync(onSuccess: @escaping([Breakdown]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getBreakdownWithUserIdAndNumberOfWeeks(userId: DataManager.DUMMY_USER_ID,
                                                                            numberOfWeeks: DataManager.DUMMY_NUMBER_OF_WEEKS,
                                                                            onSuccess:
            { json in
                print("[DataManager] getBreakdownsAsync success! Parsing JSON...")
                self._breakdowns = []
                print(json)
                print(json.array)
                // parse JSON
                for item in json[self.BREAKDOWNS_JSON_KEY].array! {
                    let amounts = item[self.AMOUNTS_JSON_KEY].array
                    var amountsDouble: [Double] = []
                    
                    for d in amounts! {
                        amountsDouble.append(d.double!)
                    }
                    
                    let category = item[self.CATEGORY_JSON_KEY].string
                    print(category)
                    print(amountsDouble)
                    self._breakdowns?.append(Breakdown(category: category!, amounts: amountsDouble)!)
                }
                
                onSuccess(self._breakdowns!)
        }, onFailure: { error in
            print("[DataManager][Error] getBreakdownsAsync")
            onFailure(error)
        })
    }
    
    /// getTransactionsAsyc: asynchronously queries the backend for the user's transaction data  and parses the result
    ///
    /// - Parameters:
    ///   - onSuccess: returns array of Transactions [Transaction]
    ///   - onFailure: returns Error
    func getTransactionsAsync(onSuccess: @escaping([Transaction]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getTransactionsWithUserId(userId: DataManager.DUMMY_USER_ID,
                                                             onSuccess:
        {(json) in
            print("[DataManager] getTransactionsAsync success! Parsing JSON...")
            self._transactions = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.DATE_FORMATTER

            // parse JSON
            for item in json.array! {
                let date = dateFormatter.date(from: item[self.DATE_JSON_KEY].string!)
                let userId = item[self.USER_ID_JSON_KEY].int
                let transactionId = item[self.TRANSACTION_ID_JSON_KEY].int
                let amount = item[self.AMOUNT_JSON_KEY].double
                let category = item[self.CATEGORY_JSON_KEY].string
                let description = item[self.DESCRIPTION_JSON_KEY].string
                self._transactions?.append(Transaction(transactionId: transactionId!, userId: userId!, category: category!, description: description!, amount: amount!, date: date!)!)
            }

            onSuccess(self._transactions!)
            
        }, onFailure: { (error) in
            print("[DataManager][Error] getTransactionsAsync")
            onFailure(error)
        })

    }
    
    /// getReceiptsAsync: asynchronously queries the backend for the user's Receipt data and parses the result
    ///
    /// - Parameters:
    ///   - onSuccess: return array of Receipts [Receipt]
    ///   - onFailure: returns Error
    func getReceiptsAsync(onSuccess: @escaping([Receipt]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getReceiptsWithUserId(userId: DataManager.DUMMY_USER_ID,
                                                         maxNumber: nil,
                                                            offset: nil,
                                                            onSuccess:
        { (json) in
            print("[DataManager] getReceiptsAsync success! Parsing JSON...")
            self._receipts = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.DATE_FORMATTER
            
            // parse JSON
            for item in json.array! {
                let date = dateFormatter.date(from: item[self.DATE_JSON_KEY].string!)
                let userId = item[self.USER_ID_JSON_KEY].int
                let transactionId = item[self.TRANSACTION_ID_JSON_KEY].int
                let thumbnailData = item[self.THUMBNAIL_IMAGE_DATA_JSON_KEY].string
                self._receipts?.append(Receipt(transactionId: transactionId!, userId: userId!, date: date!, thumbnailImageBase64String: thumbnailData!)!)
            }
            
            onSuccess(self._receipts!)
            
        }, onFailure: { (error) in
            print("[DataManager][Error] getReceiptsAsync")
            onFailure(error)
        })
    }
    
    /// getReceiptImageAsync: asynchronously queries the backend for the user's receipt image data and parses the result
    ///
    /// - Parameters:
    ///   - transactionId: id of the transaction to request receipt image for
    ///   - onSuccess: returns UIImage containing receipt image
    ///   - onFailure: returns Error
    func getReceiptImageAsync(transactionId: Int, onSuccess: @escaping(UIImage) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.getReceiptImageWithTransactionId(transactionId: transactionId,
                                                                           onSuccess:
        { (json) in
            let base64String = json[self.IMAGE_JSON_KEY].string!
            let data = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
            let image = UIImage(data: data as Data)!
            onSuccess(image)
        }, onFailure: { (error) in
            print("[DataManager][Error] getReceiptImageAsync")
            onFailure(error)
        })
    }
    
    /// postReceiptImgAsync: asynchronously queries the backend to add a new transaction for the user and parses the result
    ///
    /// - Parameters:
    ///   - categoryField: category of the expense
    ///   - descriptionField: description of the expense
    ///   - imageData: base64 encoded image string of the expense
    ///   - onSuccess: returns [ReceiptTransactionAmount] containing transactionId and amount
    ///   - onFailure: returns Error
    func postReceiptImgAsync(categoryField: Swift.String, descriptionField: Swift.String, imageData: Swift.String, onSuccess: @escaping([ReceiptTransactionAmount]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.postReceiptImgWithUserIdCategoryDescriptionData(userId: DataManager.DUMMY_USER_ID, category: categoryField, description: descriptionField, imgData: imageData, onSuccess:
            {(json) in
                print("[DataManager] postReceiptImgAsync success! Parsing JSON...")
                self._receiptTransactions = []
                print(json)
                print(json.dictionaryObject!)
                // parse JSON
                let transactionId : String = json["transactionId"].description
                let amount : Double = json["amount"].doubleValue
                self._receiptTransactions?.append(ReceiptTransactionAmount(transactionId: Int(transactionId)!, amount: amount)!)
               
                onSuccess(self._receiptTransactions!)
                
        }, onFailure: { (error) in
            print("[DataManager][Error] postReceiptImgAsync")
            onFailure(error)
        })
        
    }
    
    /// postUpdateTransactionAsync: asynchronously queries the backend to update the amount of a transaction and parses the result
    ///
    /// - Parameters:
    ///   - transactionId: transaction to update
    ///   - amount: new amount to write into transaction info
    ///   - onSuccess: returns [ReceiptTransactionAmount] confirming data
    ///   - onFailure: returns Error
    func postUpdateTransactionAsync(transactionId: Int, amount: Double, onSuccess: @escaping([ReceiptTransactionAmount]) -> Void, onFailure: @escaping(Error) -> Void) {
        RequestManager.sharedInstance.postUpdateTransaction(transactionId: transactionId, amount: amount, onSuccess:
            {(json) in
                print("[DataManager] postUpdateTransactionAsync success! Parsing JSON...")
                self._receiptTransactions = []
                print(json)
//                print(json.dictionaryObject!)
                // parse JSON
//                let transactionId : String = json["transactionId"].description
//                let amount : Double = json["amount"].doubleValue
//                self._receiptTransactions?.append(ReceiptTransactionAmount(transactionId: transactionId, amount: amount)!)
                
                onSuccess(self._receiptTransactions!)
                
        }, onFailure: { (error) in
            print("[DataManager][Error] postUpdateTransactionAsync")
            onFailure(error)
        })
        
    }
}
