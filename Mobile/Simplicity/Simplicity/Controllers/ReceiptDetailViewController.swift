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
    var imageView: UIImageView?
    
    init(receipt: Receipt) {
        super.init(nibName: nil, bundle: nil)
        self.receipt = receipt
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipt Detail"
        
        let mainNavigationBar = LeftBackNavigationBar(frame: view.frame, title: "", parentVC: self)
        view.addSubview(mainNavigationBar)
        
        imageView = UIImageView(frame: CGRect(x: 0,
                                              y: mainNavigationBar.frame.height,
                                          width: self.view.frame.width,
                                         height: self.view.frame.height))
        imageView!.image = UIImage.init(named: "default_receipt")
        imageView!.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        
        setupReceiptImage()
    }
    
    func setupReceiptImage() {
        if receipt?.fullScreenImage != nil {
            print("[ReceiptDetailVC][setupReceiptImage] Setting image")
            DispatchQueue.main.async {
                self.imageView!.image = self.receipt!.fullScreenImage
            }
        } else {
            print("[ReceiptDetailVC][setupReceiptImage] Downloading image with transactionId = \(receipt?.trancationId ?? -1)")
            getReceiptImageData()
        }
    }
    
    func getReceiptImageData() {
        DataManager.sharedInstance.getReceiptImageAsync(transactionId: receipt!.trancationId,
                                                        onSuccess:
        { (image) in
            self.receipt!.fullScreenImage = image
            self.setupReceiptImage()
        }, onFailure: { (error) in
            print("[ReceiptDetailVC][getReceiptImageData] Error")
        })
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
