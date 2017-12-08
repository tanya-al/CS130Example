//
//  ReceiptsViewController.swift
//  Simplicity
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class ReceiptsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let RECEIPT_DATA_NOTIFICATION = "receiptDataNotification"
    let DEFAULT_RECEIPT_COUNT = 50
    let RECEIPT_PER_ROW = 4
    let EDGE_INSETS: CGFloat = 5
    let RECEIPT_THUMBNAIL_MARGIN: CGFloat = 5
    
    // MARK: Properties
    var mainNavigationBar: MainNavigationBar?
    //var collectionView: UICollectionView?
    var receipts: [Receipt]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipts"
        
        mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Receipts")
        view.addSubview(mainNavigationBar!)
        

        setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiptsViewController.receiptDataReceived), name: Notification.Name(RECEIPT_DATA_NOTIFICATION) , object: nil)
        getReceiptData()
        //setupCollectionView()
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 60, height: 60)
        
        //let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        myCollectionView.dataSource = self
//        myCollectionView.delegate = self
        //myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//        myCollectionView.backgroundColor = UIColor.blue
//        self.view.addSubview(myCollectionView)
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: EDGE_INSETS, left: EDGE_INSETS, bottom: EDGE_INSETS, right: EDGE_INSETS)
        layout.minimumLineSpacing = RECEIPT_THUMBNAIL_MARGIN
        layout.minimumInteritemSpacing = RECEIPT_THUMBNAIL_MARGIN
        
        let receiptThumbnailSize = (collectionView!.frame.width - RECEIPT_THUMBNAIL_MARGIN * CGFloat(RECEIPT_PER_ROW - 1) - EDGE_INSETS * 2) / CGFloat(RECEIPT_PER_ROW)
        
        layout.itemSize = CGSize(width: receiptThumbnailSize, height: receiptThumbnailSize)
        
        collectionView!.collectionViewLayout = layout
        
//        collectionView = UICollectionView(frame: CGRect(x: 0,
//                                                        y: mainNavigationBar!.frame.height,
//                                                        width: self.view.frame.width,
//                                                        height: self.view.frame.height - mainNavigationBar!.frame.height),
//                                          collectionViewLayout: layout)
        collectionView!.frame = CGRect(x: 0,
                                       y: mainNavigationBar!.frame.height,
                                   width: self.view.frame.width,
                                  height: self.view.frame.height - mainNavigationBar!.frame.height)
        
        //let cell = UICollectionViewCell()
        
        collectionView!.register(ReceiptCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.backgroundColor = UIColor.white
        
        //collectionView!.dataSource = self
        //collectionView!.delegate = self
        
        //self.view.addSubview(collectionView!)
    }
    
    func getReceiptData() {
        print("[ReceiptsVC][getReceiptData] Getting receipts data")
        DataManager.sharedInstance.getReceiptsAsync(onSuccess: { (receipts) in
            self.receipts = receipts
            NotificationCenter.default.post(name: Notification.Name(self.RECEIPT_DATA_NOTIFICATION), object: nil)
            //NotificationCenter.default.addObserver(observer: self, selector: #selector(ReceiptsViewController.receiptDataReceived(notification:)), name: nil, object: nil)
            //(onMainThread: #selector(ReceiptsViewController.receiptDataReceived(notification:)), with: nil, waitUntilDone: false)
            //NotificationCenter.default.postNotificationName(RECEIPT_DATA_NOTIFICATION, object: nil)
        }) { (error) in
            print("[ReceiptsVC][getReceiptData] Error")
        }
    }

    @objc func receiptDataReceived() {
        print("[ReceiptsVC][receiptDataReceived] Called")
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
//    @objc func receiptDataReceived(notification: NSNotification) {
//        print("[ReceiptsVC][receiptDataReceived] Called")
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("numbers?")
        //return 100
        let count = receipts != nil ? receipts!.count : DEFAULT_RECEIPT_COUNT
        print("[ReceiptsVC][numberOfItemsInSection] Count = \(count)")
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReceiptCell
        cell.imageView.image = receipts != nil ? receipts![indexPath.row].thumbnailImage : UIImage.init(named: "default_receipt")
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}
