//
//  Transaction.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/10/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation

class Transaction {
    
    // MARK: Properties
    
    var trancationId: Int
    var userId: Int
    var category: String
    var description: String
    var amount: Double
    var date: Date
    
    
    // MARK: Initialization
    init?(transactionId: Int, userId: Int, category: String, description: String, amount: Double, date: Date) {
        
        if (transactionId < 1 || userId < 1 || amount < 0.0) {
            return nil
        }
        
        self.trancationId = transactionId
        self.userId = userId
        self.category = category
        self.description = description
        self.amount = amount
        self.date = date
    }
}
