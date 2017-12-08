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
    
    // MARK: Properties
    var mainNavigationBar: MainNavigationBar?
    //var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        self.title = "Receipts"
        
        mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Receipts")
        view.addSubview(mainNavigationBar!)
        

        setupCollectionView()
        
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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
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
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.backgroundColor = UIColor.blue
        
        //collectionView!.dataSource = self
        //collectionView!.delegate = self
        
        //self.view.addSubview(collectionView!)
    }
    
    // MARK: UICollectionViewDataSource
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numbers?")
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
