//
//  AddViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
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
//        let secondViewController:CameraViewController = CameraViewController()
//        self.present(secondViewController, animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.lightGray
        self.title = "Add"
        
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
        let verticalCenter: CGFloat = UIScreen.main.bounds.midY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let takePhotoButton = UIButton(frame: CGRect(origin: CGPoint(), size: CGSize(width : 240, height : 40)))
        takePhotoButton.backgroundColor = UIColor.lightGray
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.titleLabel?.font = UIFont(name : "Times New Roman", size : 24)
        takePhotoButton.addTarget(self, action: #selector(transitionToCamera), for: .touchUpInside)
        takePhotoButton.center = CGPoint(x: horizontalCenter, y: verticalCenter-80)

        self.view.addSubview(takePhotoButton)
        
        let uploadPhotoButton = UIButton(frame: CGRect(origin: CGPoint(), size: CGSize(width : 240, height : 40)))
        uploadPhotoButton.backgroundColor = UIColor.lightGray
        uploadPhotoButton.setTitle("Upload Photo", for: .normal)
        uploadPhotoButton.titleLabel?.font = UIFont(name : "Times New Roman", size : 24)
        uploadPhotoButton.addTarget(self, action: #selector(transitionToUpload), for: .touchUpInside)
        uploadPhotoButton.center = CGPoint(x: horizontalCenter, y: verticalCenter+80)
        
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
