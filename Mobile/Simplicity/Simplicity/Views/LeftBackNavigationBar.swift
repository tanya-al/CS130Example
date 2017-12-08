//
//  LeftBackNavigationBar.swift
//  Simplicity
//
//  Created by Anthony Lai on 12/7/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class LeftBackNavigationBar: MainNavigationBar {
    
    // MARK: Initialization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
    // MARK: Properties
    weak var parentVC: UIViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, title: String) {
        super.init(frame: frame, title: title)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.init(named: "back"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(LeftBackNavigationBar.backAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 20, y: self.center.y, width: 12, height: 20)
        self.addSubview(backButton)
    }
    
    convenience init(frame: CGRect, title: String, parentVC: UIViewController) {
        self.init(frame: frame, title: title)
        self.parentVC = parentVC
    }
    
    @objc func backAction() {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
}
