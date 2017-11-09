//
//  MainNavigationBar.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class MainNavigationBar: UIView {
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(displayP3Red: 144/256, green: 216/256, blue: 93/256, alpha: 100)
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: 64)
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24)
        label.sizeToFit()
        label.center = CGPoint(x: self.center.x, y: self.center.y + 10)
        self.addSubview(label)
    }
}

