//
//  ReceiptDetailViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 12/7/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {

    var receipt: Receipt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipt"
        
        let mainNavigationBar = LeftBackNavigationBar(frame: view.frame, title: "", parentVC: self)
        view.addSubview(mainNavigationBar)
        
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: mainNavigationBar.frame.height,
                                              width: self.view.frame.width,
                                             height: self.view.frame.height))
        imageView.image = UIImage.init(named: "default_receipt")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
