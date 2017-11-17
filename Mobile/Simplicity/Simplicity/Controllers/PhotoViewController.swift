//
//  PhotoViewController.swift
//  Simplicity
//
//  Created by Tanya A on 11/16/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    var takenPhoto : UIImage?
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
//        view.backgroundColor = UIColor.white
//        self.title = "Add"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
