//
//  ViewController.swift
//  DDCustomCollectionLayout
//
//  Created by WY on 2019/2/28.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var button =   UIButton(frame: CGRect(x: 0, y: 22, width: 44, height: 44))
    lazy var itemsCount  = 6
    lazy var layout: DDFoldedLayout  = {
        let config: FoldedLayoutConfig = FoldedLayoutConfig(itemHeight: collectionW, itemWidth: collectionW, columnCount: 1, columnMargin: 8, rowMargin: 8, edgeInsets: .zero, sessionHeaderHeight: 0, itemsCount: itemsCount)
        let lay = DDFoldedLayout(config: config)
        lay.scrollDirection = .vertical
        return lay
    }()
    lazy var collectionW  = view.bounds.width - 120
    lazy var collection : UICollectionView = {
        let frame = CGRect(x: 60, y: 40, width: collectionW, height: UIScreen.main.bounds.height - 82)
        let c = UICollectionView(frame: frame, collectionViewLayout: layout)
        return c
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            collection.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            collection.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(button)
        button.addTarget(self , action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        button.backgroundColor = .blue
        //        button.
        view.backgroundColor = .red
        view.addSubview(collection)
        collection.delegate = self
        collection.dataSource = self
        collection.register(MyItem.self, forCellWithReuseIdentifier: "xxxxx")
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func btnClick(sender : UIButton) {
        layout.updateState()
        UIView.animate(withDuration: 1.4) {
            self.collection.performBatchUpdates({
                self.collection.reloadData()
            }) { (complate) in
            }
            
        }
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item =  collectionView.dequeueReusableCell(withReuseIdentifier: "xxxxx", for: indexPath) as! MyItem
        item.label.text = "\(indexPath.item)"
        item.backgroundColor = .green
        return item
    }
    
    
}
class MyItem: UICollectionViewCell {
    lazy var imageview = UIImageView(image: UIImage(named: "baby"))
    lazy var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageview)
        self.contentView.addSubview(label)
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        //        imageview.contentMode = .scaleAspectFit
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageview.frame = self.bounds
        label.frame = CGRect(x: 10, y: bounds.height - 15, width: bounds.width, height: 15)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
