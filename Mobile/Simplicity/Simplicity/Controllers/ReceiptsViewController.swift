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
    let SEGUE_IDENTIFIER = "receiptDetailSegue"
    
    // MARK: Properties
    var mainNavigationBar: MainNavigationBar?
    var receipts: [Receipt]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipts"
        
        mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Receipts")
        view.addSubview(mainNavigationBar!)
        
        setupCollectionView()
        NotificationCenter.default.addObserver(self,
                                            selector: #selector(ReceiptsViewController.receiptDataReceived),
                                                name: Notification.Name(RECEIPT_DATA_NOTIFICATION) ,
                                              object: nil)
        getReceiptData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshReceiptsData(_:)), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: EDGE_INSETS, left: EDGE_INSETS, bottom: EDGE_INSETS, right: EDGE_INSETS)
        layout.minimumLineSpacing = RECEIPT_THUMBNAIL_MARGIN
        layout.minimumInteritemSpacing = RECEIPT_THUMBNAIL_MARGIN
        
        let receiptThumbnailSize = (collectionView!.frame.width - RECEIPT_THUMBNAIL_MARGIN * CGFloat(RECEIPT_PER_ROW - 1) - EDGE_INSETS * 2) / CGFloat(RECEIPT_PER_ROW)
        layout.itemSize = CGSize(width: receiptThumbnailSize, height: receiptThumbnailSize)
        collectionView!.collectionViewLayout = layout

        collectionView!.frame = CGRect(x: 0,
                                       y: mainNavigationBar!.frame.height,
                                   width: self.view.frame.width,
                                  height: self.view.frame.height - mainNavigationBar!.frame.height)
        
        collectionView!.register(ReceiptCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.backgroundColor = UIColor.white
    }
    
    func getReceiptData() {
        print("[ReceiptsVC][getReceiptData] Getting receipts data...")
        DataManager.sharedInstance.getReceiptsAsync(onSuccess: { (receipts) in
            self.receipts = receipts
            NotificationCenter.default.post(name: Notification.Name(self.RECEIPT_DATA_NOTIFICATION), object: nil)
        }, onFailure: { (error) in
            print("[ReceiptsVC][getReceiptData] Error")
        })
    }

    @objc func receiptDataReceived() {
        print("[ReceiptsVC][receiptDataReceived] Called")
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
    
    @objc private func refreshReceiptsData(_ sender: Any) {
        print("[ReceiptsVC][refreshReceiptsData]")
        DataManager.sharedInstance.getReceiptsAsync(onSuccess: { (receipts) in
            print("[ReceiptsVC][refreshReceiptsData] Success!")
            self.receipts = receipts
            
            DispatchQueue.main.async {
                self.collectionView!.reloadData()
                self.collectionView!.refreshControl?.endRefreshing()
            }
            
        }, onFailure: { (error) in
            print("[ReceiptsVC][refreshReceiptsData] Error")
            DispatchQueue.main.async {
                self.collectionView!.refreshControl?.endRefreshing()
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        print("[ReceiptsVC][didSelectItemAt] User tapped on item \(indexPath.row)")
        if receipts != nil {
            let vc = ReceiptDetailViewController(receipt: receipts![indexPath.row])
            self.present(vc, animated: true, completion: nil)
        }
    }
}
