//
//  PhotoViewController.swift
//  Simplicity
//
//  Created by Tanya A on 11/16/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PhotoViewController: UIViewController {
    
//    var takenPhoto : UIImage?
    var imageView : UIImageView!
//    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    init(capturedImage : UIImageView?) {
        super.init(nibName: nil, bundle: nil)
        self.imageView = capturedImage
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
//        if let availableImage = takenPhoto {
//            imageView.image = self.image
//        }
        imageView.frame = CGRect(x:0, y:64, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        self.view.insertSubview(imageView, at: 0)
//        view.backgroundColor = UIColor.white
//        self.title = "Add"
    
//        view.layer.insertSublayer(videoPreviewLayer!, at: 0)
//        videoPreviewLayer?.frame = view.frame
        displayButton()
    }
    
    func displayButton() {
        view.backgroundColor = UIColor.white
        let verticalBottom: CGFloat = UIScreen.main.bounds.maxY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let captureButton = UIButton(type: .custom)
        captureButton.frame = CGRect(x: self.view.frame.size.width - 20, y: 42, width: 40, height: 40)
        captureButton.layer.cornerRadius = 0.5 * captureButton.bounds.size.width
        captureButton.clipsToBounds = true
        captureButton.backgroundColor = .red
        captureButton.center = CGPoint(x: horizontalCenter, y: verticalBottom-40)
        captureButton.setTitle("test", for: UIControlState.normal)
//        captureButton.addTarget(self, action: #selector(displayCamera(on:)), for: .touchUpInside)
        self.view.insertSubview(captureButton, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
