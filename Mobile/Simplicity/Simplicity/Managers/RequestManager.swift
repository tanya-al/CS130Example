//
//  RequestManager.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/2/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import SwiftyJSON

class RequestManager: NSObject {
    
    let baseURL = "https://jsonplaceholder.typicode.com"
    static let sharedInstance = RequestManager()    // singleton
    static let getPostsEndpoint = "/posts/"
    
    func getPostWithId(postId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url: String = baseURL + RequestManager.getPostsEndpoint + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
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
