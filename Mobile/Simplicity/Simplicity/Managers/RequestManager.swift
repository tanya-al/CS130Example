//
//  RequestManager.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/2/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import SwiftyJSON

class RequestManager: NSObject {
    
    let baseURL = "http://107.170.227.29:5000/"
    static let sharedInstance = RequestManager()    // singleton
    
    static let getOverviewEndpoint = "overview"
    static let getTransactionsEndpoint = "transactions"
    
    static let userIdParam = "userId"
    static let numberOfWeeksParam = "weeks"
    
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
    
    func getTransactionsWithUserId(userId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        // setup URL
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestManager.userIdParam, value: String(userId)))
        
        // setup parameters
        let urlComp = NSURLComponents(string: baseURL + RequestManager.getTransactionsEndpoint)!
        urlComp.queryItems = queryItems
        
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
}
