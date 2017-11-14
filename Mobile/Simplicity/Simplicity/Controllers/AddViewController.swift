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
    
    @objc func transitionToCamera(sender: UIButton!) {
        let secondViewController:CameraViewController = CameraViewController()
        self.present(secondViewController, animated: true, completion: nil)

    }
    
    @objc func transitionToUpload(sender: UIButton!) {
        let secondViewController:CameraViewController = CameraViewController()
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Add"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        let takePhotoButton = UIButton(frame: CGRect(x : (screenWidth - 240) / 2, y : (screenHeight - 40) / 2, width : 240, height: 40))
        takePhotoButton.backgroundColor = UIColor.lightGray
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.addTarget(self, action: #selector(transitionToCamera), for: .touchUpInside)
        
        self.view.addSubview(takePhotoButton)
        
        let uploadPhotoButton = UIButton(frame: CGRect(origin: CGPoint(x : self.view.frame.midX, y : self.view.frame.midY+80), size: CGSize(width : 240, height : 40)))
        uploadPhotoButton.backgroundColor = UIColor.lightGray
        uploadPhotoButton.setTitle("Upload Photo", for: .normal)
        uploadPhotoButton.addTarget(self, action: #selector(transitionToUpload), for: .touchUpInside)
        
        self.view.addSubview(uploadPhotoButton)
        
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
