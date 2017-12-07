//
//  Breakdown.swift
//  Simplicity
//
//  Created by Anthony Lai on 11/22/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation

class Breakdown {
    
    // MARK: Properties
    
    var category: String
    var amounts: [Double]
    
    
    // MARK: Initialization
    init?(category: String, amounts: [Double]) {
        
        if (category.isEmpty || amounts.isEmpty) {
            return nil
        }
        
        self.category = category
        self.amounts = amounts
    }
}
