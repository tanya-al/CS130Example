//
//  AddViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    // for testing RequestManager
//    var testDataView: UITextView
//
//    // MARK: Initialization
//    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        testDataView = UITextView()
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Add"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
        
        // for testing RequestManager
//        let testButton = UIButton(type: .system)
//        testButton.frame = CGRect(x: 50, y: 250, width: 100, height: 100)
//        testButton.backgroundColor = UIColor.blue
//        testButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
//        view.addSubview(testButton)
//        
//        testDataView.frame = CGRect(x: 0, y: 400, width: view.frame.width, height: 300)
//        view.addSubview(testDataView)
    }
    
        // for testing RequestManager
//    @objc func testButtonPressed(sender: UIButton!) {
//        RequestManager.sharedInstance.getPostWithId(postId: 1, onSuccess: { json in
//            DispatchQueue.main.async {
//                self.testDataView.text = String(describing: json)
//            }
//        }, onFailure: { error in
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.show(alert, sender: nil)
//        })
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
