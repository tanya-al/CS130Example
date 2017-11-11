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
    var thumbnailImage: UIImage
    var fullScreenImage: UIImage?
    
    // MARK: Initialization
    init?(transactionId: Int, userId: Int, thumbnailImage: UIImage, fullScreenImage: UIImage?) {
        
        if (transactionId < 1 || userId < 1) {
            return nil
        }
        
        self.trancationId = transactionId
        self.userId = userId
        self.thumbnailImage = thumbnailImage
        self.fullScreenImage = fullScreenImage
        
    }
}
