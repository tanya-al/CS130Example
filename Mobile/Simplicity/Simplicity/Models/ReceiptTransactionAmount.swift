//
//  ReceiptImage.swift
//  Simplicity
//
//  Created by Tanya A on 12/12/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import UIKit

class ReceiptTransactionAmount {
    
    // MARK: Properties
    
    var transactionId: Int
    var amount: Double
    
    // MARK: Initialization
    init?(transactionId: Int, amount: Double) {
        
        if (transactionId < 1) {
            return nil
        }
        
        self.transactionId = transactionId
        self.amount = amount
        
    }
    
//    convenience init?(userId: Int, category: Category, description: String, imgData: String) {
//        let data = NSData(base64Encoded: imgData, options: .ignoreUnknownCharacters)!
//        let image = UIImage(data: data as Data)!
//        self.init(userId: userId, category: nil, description: "", imgData: image)
//    }
}
