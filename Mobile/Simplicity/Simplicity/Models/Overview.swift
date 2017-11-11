//
//  Overview.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/10/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation

class Overview {
    
    // MARK: Properties
    
    var category: String
    var amount: Double
    var percentage: Double
    
    
    // MARK: Initialization
    init?(category: String, amount: Double, percentage: Double) {
        
        if (amount < 0.0 || percentage < 0.0) {
            return nil
        }

        self.category = category
        self.amount = amount
        self.percentage = percentage
    }
}
