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
    
    static let userIdParam = "userId"
    static let transactionIdParam = "transactionId"
    static let numberOfWeeksParam = "weeks"
    static let maxNumberReceipts = "max"
    static let offsetNumberReceipts = "offset"
    static let categoryParam = "category"
    static let descriptionParam = "description"
    static let imgDataParam = "data"
    
    private override init() {
        super.init()
    }
    
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
    
    func getTransactionsWithUserId(userId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getTransactionsEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
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
    
    func getReceiptImageWithTransactionId(transactionId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.transactionIdParam, value: String(transactionId)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getReceiptImageEndpoint)!
        urlComp.queryItems = queryItems
        
        getRequest(urlComp: urlComp, onSuccess: onSuccess, onFailure: onFailure)
    }
    
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
