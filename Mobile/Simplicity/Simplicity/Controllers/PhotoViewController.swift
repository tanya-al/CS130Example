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
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
        imageView.frame = CGRect(x:0, y:64, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height-64)
        self.view.addSubview(imageView)
    
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
        self.view.addSubview(captureButton)
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "Photo Taken", message: "Please enter a description and category for your expense.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Receipt Description"
        })
        alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Category of Expense"
        })
        let confirmAction = UIAlertAction(title: "Submit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Current description \(String(describing: alert.textFields?[0].text))")
            let description = alert.textFields?[0].text
            let category = alert.textFields?[1].text
            //send to backend
            let imageData: NSData = UIImageJPEGRepresentation(self.imageView.image!, 0.4)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            DataManager.sharedInstance.postReceiptImgAsync(categoryField: category!, descriptionField: description!, imageData: strBase64, onSuccess: {suggestedTransaction in
                let amount = suggestedTransaction[0].amount
                let transactionId = suggestedTransaction[0].transactionId
                let newAlert = UIAlertController(title: "Confirm Transaction", message: String("Total expense is $"+String(amount)+". Is this correct?"), preferredStyle: UIAlertControllerStyle.alert)
                let confirmAmount = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    let cameraVC = CameraViewController()
                    
                    DispatchQueue.main.async {
                        self.present(cameraVC, animated: true, completion: nil)
                    }
                })
                newAlert.addAction(confirmAmount)
                let denyAmount = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    
                })
                newAlert.addAction(denyAmount)
                self.present(newAlert, animated: true, completion: nil)
            }, onFailure: {error in
                print("[PhotoVC][Error] Error in getting data")
            })
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
