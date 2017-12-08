//
//  Receipt.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/10/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class Receipt {
    
    // MARK: Properties
    
    var trancationId: Int
    var userId: Int
    var date: Date
    var thumbnailImage: UIImage
    var fullScreenImage: UIImage?
    
    // MARK: Initialization
    init?(transactionId: Int, userId: Int, date: Date, thumbnailImage: UIImage, fullScreenImage: UIImage?) {
        
        if (transactionId < 1 || userId < 1) {
            return nil
        }
        
        self.trancationId = transactionId
        self.userId = userId
        self.date = date
        self.thumbnailImage = thumbnailImage
        self.fullScreenImage = fullScreenImage
        
    }
    
    convenience init?(transactionId: Int, userId: Int, date: Date, thumbnailImageBase64String: String) {
        let data = NSData(base64Encoded: thumbnailImageBase64String, options: .ignoreUnknownCharacters)!
        let image = UIImage(data: data as Data)!
        self.init(transactionId: transactionId, userId: userId, date: date, thumbnailImage: image, fullScreenImage: nil)
    }
}
