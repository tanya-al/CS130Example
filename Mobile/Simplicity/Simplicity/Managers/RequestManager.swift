//
//  RequestManager.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/2/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import SwiftyJSON

class RequestManager: NSObject {
    
    let baseURL = "http://165.227.217.185:5000/"
    static let sharedInstance = RequestManager()    // singleton
    
    static let getOverviewEndpoint = "overview"
    static let getTransactionsEndpoint = "transactions"
    static let getBreakdownEndpoint = "breakdown"
    static let getReceiptsEndpoint = "receipts"
    static let getReceiptImageEndpoint = "receipt_img"
    static let postReceiptsEndpoint = "receipt"
    static let postUpdateTransactionEndpoint = "update_transaction"
    
    static let userIdParam = "userId"
    static let transactionIdParam = "transactionId"
    static let numberOfWeeksParam = "weeks"
    static let maxNumberReceipts = "max"
    static let offsetNumberReceipts = "offset"
    static let categoryParam = "category"
    static let descriptionParam = "description"
    static let imgDataParam = "data"
    static let amountParam = "amount"
    
    private override init() {
        super.init()
    }
    
    /// getOverviewWithUserIdAndNumberOfWeeks: handles construction/sending of backend query via NSURLComponents
    ///
    /// - Parameters:
    ///   - userId: the user's id
    ///   - numberOfWeeks: the number of weeks to display data for
    ///   - onSuccess: return JSON containing overview info
    ///   - onFailure: returns Error
    func getOverviewWithUserIdAndNumberOfWeeks(userId: Int, numberOfWeeks: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        queryItems.append(URLQueryItem(name: RequestManager.numberOfWeeksParam, value: String(numberOfWeeks)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getOverviewEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// getBreakdownWithUserIdAndNumberOfWeeks: handles construction/sending of backend query via NSURLComponents
    ///
    /// - Parameters:
    ///   - userId: given userId
    ///   - numberOfWeeks: number of weeks for breakdown
    ///   - onSuccess: returns JSON obj from server
    ///   - onFailure: returns Error
    func getBreakdownWithUserIdAndNumberOfWeeks(userId: Int, numberOfWeeks: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        queryItems.append(URLQueryItem(name: RequestManager.numberOfWeeksParam, value: String(numberOfWeeks)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getBreakdownEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// getTransactionsWithUserId: handles construction/sending of backend query via NSURLComponents
    ///
    /// - Parameters:
    ///   - userId: given userId
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    func getTransactionsWithUserId(userId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getTransactionsEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// getReceiptsWithUserId: handles construction/sending of backend query via NSURLComponents
    ///
    /// - Parameters:
    ///   - userId: given userId
    ///   - maxNumber: given maxNumber of images to load
    ///   - offset: offset of images
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    func getReceiptsWithUserId(userId: Int, maxNumber: Int?, offset: Int?, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        if maxNumber != nil {
            queryItems.append(URLQueryItem(name: RequestManager.maxNumberReceipts, value: String(maxNumber!)))
        }
        if offset != nil {
            queryItems.append(URLQueryItem(name: RequestManager.offsetNumberReceipts, value: String(offset!)))
        }
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getReceiptsEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// getReceiptImageWithTransactionId: handles construction/sending of backend query via NSURLComponents
    ///
    /// - Parameters:
    ///   - transactionId: id of the transaction/expense
    ///   - onSuccess: returns JSON info from server
    ///   - onFailure: returns Error
    func getReceiptImageWithTransactionId(transactionId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.transactionIdParam, value: String(transactionId)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getReceiptImageEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// getRequest: helper function to send the URL to server
    ///
    /// - Parameters:
    ///   - urlComp: url components from other functions
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    private func getRequest(urlComp: NSURLComponents, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        // setup request
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                let result = JSON(data: data!)
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    /// postReceiptImgWithUserIdCategoryDescriptionData: handles construction/sending of backend query via NSURLComponents and JSON
    ///
    /// - Parameters:
    ///   - userId: given userId
    ///   - category: category of transaction
    ///   - description: description of transaction
    ///   - imgData: image data of transaction
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    func postReceiptImgWithUserIdCategoryDescriptionData(userId: Int, category: String, description: String, imgData: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var params: [String: Any] = [:]
        params[RequestManager.userIdParam] = String(userId)
        params[RequestManager.categoryParam] = String(category)
        params[RequestManager.descriptionParam] = String(description)
        params[RequestManager.imgDataParam] = String(imgData)
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.postReceiptsEndpoint)!
        
        postRequest(urlComp: urlComp, jsonObj: params, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// postUpdateTransaction: handles construction/sending of backend query via NSURLComponents and JSON
    ///
    /// - Parameters:
    ///   - transactionId: transaction id of expense
    ///   - amount: amount to update expense cost to
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    func postUpdateTransaction(transactionId: Int, amount: Double, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var params: [String: Any] = [:]
        params[RequestManager.transactionIdParam] = String(transactionId)
        params[RequestManager.amountParam] = String(amount)
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.postUpdateTransactionEndpoint)!
        
        postRequest(urlComp: urlComp, jsonObj: params, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    /// postRequest: helper function to send the URL and JSON data to server
    ///
    /// - Parameters:
    ///   - urlComp: URL components from other functions
    ///   - jsonObj: POST data in JSON format
    ///   - onSuccess: returns JSON from server
    ///   - onFailure: returns Error
    private func postRequest(urlComp: NSURLComponents, jsonObj: [String: Any], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        // setup request
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        print("Request")
//        print(request)
        print("httpBody")
        print(request.httpBody!)
        print("JSON")
        print(JSON(request.httpBody!))
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print("error")
                onFailure(error!)
            } else{
                print("Data")
//                print(data!)
                print("response")
                print(response!)
                let result = JSON(data: data!)
                print("result")
                print(result)
                onSuccess(result)
            }
        })
        task.resume()
    }
}
