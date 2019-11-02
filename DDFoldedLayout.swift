//
//  DDFoldedLayout.swift
//  DDCustomCollectionLayout
//
//  Created by JohnConnor on 2019/11/1.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
struct FoldedLayoutConfig {
    let itemHeight: CGFloat
    let itemWidth: CGFloat
    let columnCount: Int
    let columnMargin: CGFloat
    let rowMargin: CGFloat
    let edgeInsets: UIEdgeInsets
    let sessionHeaderHeight: CGFloat
    let itemsCount : Int
}
class DDFoldedLayout: UICollectionViewFlowLayout {
    private var config : FoldedLayoutConfig!
    convenience init(config: FoldedLayoutConfig) {
        self.init()
        self.config = config
    }
    var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    lazy var toppestItemW: CGFloat = config.itemWidth
    lazy var toppestItemH: CGFloat = config.itemHeight
    lazy var toppestItemX: CGFloat = 0
    lazy var toppestItemY: CGFloat = 0
    lazy var lowestItemW: CGFloat = config.itemWidth * 0.5
    lazy var lowestItemH: CGFloat =  lowestItemW * config.itemHeight / config.itemWidth
    lazy var perProgressiveW: CGFloat = (config.itemWidth - lowestItemW ) / CGFloat(config.itemsCount)
    lazy var perProgressiveH: CGFloat  = (config.itemHeight - lowestItemH) / CGFloat(config.itemsCount)
    lazy var lowestItemX: CGFloat = (toppestItemW - lowestItemW) * 0.5
    lazy var lowestItemY: CGFloat = ( perProgressiveH + perProgressiveY) * CGFloat(config.itemsCount - 1)
    lazy var  perProgressiveX: CGFloat = (lowestItemX - toppestItemX) / CGFloat(config.itemsCount)
    lazy var  perProgressiveY: CGFloat  = 10
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let width = lowestItemW + perProgressiveW * CGFloat(indexPath.item + 1)
        let height = lowestItemH + perProgressiveH * CGFloat(indexPath.item)
        let x = lowestItemX - perProgressiveX * CGFloat(indexPath.item + 1)
        let y = lowestItemY - perProgressiveY * CGFloat(indexPath.item) - perProgressiveH *   CGFloat(indexPath.item)
        attribute.frame = CGRect(x: x   , y: y, width: width, height: height)
        attribute.alpha = CGFloat(indexPath.item + 1) / CGFloat(config.itemsCount)
        return attribute
    }
    override func prepare() {
        super.prepare()
        attributes.removeAll()
        //先考虑只有一组的情况, 而且没有header
//        columns.removeAll()
//        let _ = columnCount//chushihua
        let itemsCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        let sectionCount = self.collectionView?.numberOfSections ?? 0
        if sectionCount > 0  {
            if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)){
                attributes.append(header)
            }
        }
        for index  in 0..<itemsCount {
            let currentIndex = IndexPath(item: index, section: 0)
            if let attribute = self.layoutAttributesForItem(at: currentIndex){
                attributes.append(attribute)
            }
        }
    }
    override var collectionViewContentSize: CGSize{
        return CGSize(width: config.itemWidth, height: lowestItemY + lowestItemH)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        if indexPath.section == 0  {
            let headerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerAttribute.frame = CGRect(x: 0, y: 0, width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: 64)
            return headerAttribute
        }
        return nil
    }
}




/*
 
 struct FoldedLayoutConfig {
     let itemHeight: CGFloat
     let itemWidth: CGFloat
     let columnCount: Int
     let columnMargin: CGFloat
     let rowMargin: CGFloat
     let edgeInsets: UIEdgeInsets
     let sessionHeaderHeight: CGFloat
     let itemsCount : Int
 }
 class DDFoldedLayout: UICollectionViewFlowLayout {
     private var config : FoldedLayoutConfig!
     convenience init(config: FoldedLayoutConfig) {
         self.init()
         self.config = config
     }
     weak var  delegate :DDFlowLayoutProtocol?
     var columnCount : Int {
         let sessionHeaderH  = config.sessionHeaderHeight
         
          let column = config.columnCount
             mylog(columns.count)
             mylog(column)
             if columns.count != column {
                 columns = Array.init(repeating: sessionHeaderH, count: column)
             }
             return  column
         
     }
     var columnMargin : CGFloat {
         return config.columnMargin
     }
     var rowMargin: CGFloat{
         return config.rowMargin
     }
     var edgeInsets : UIEdgeInsets {
         return config.edgeInsets
     }
     var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
     var maxY : CGFloat = 0
     var minY : CGFloat = 0
     var columns : [CGFloat] = [CGFloat]()
     lazy var  progressiveX = config.itemWidth / CGFloat(config.itemsCount)
     lazy var  progressiveY = progressiveX * 0.5
     lazy var  yOffsetPer = progressiveX * 0.7
     
     
     lazy var itemLastestX: CGFloat = config.itemWidth/2
     lazy var theFirstItemOffsetY = CGFloat(config.itemsCount - 1) * yOffsetPer
     lazy var itemLastestY: CGFloat = progressiveY * CGFloat(config.itemsCount) + theFirstItemOffsetY
     override func prepare() {
         super.prepare()
         attributes.removeAll()
         //先考虑只有一组的情况, 而且没有header
         columns.removeAll()
         let _ = columnCount//chushihua
         let itemsCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
         let sectionCount = self.collectionView?.numberOfSections ?? 0
         if sectionCount > 0  {
             if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)){
                 attributes.append(header)
             }
         }
         for index  in 0..<itemsCount {
             let currentIndex = IndexPath(item: index, section: 0)
             if let attribute = self.layoutAttributesForItem(at: currentIndex){
                 attributes.append(attribute)
             }
         }
     }
     override var collectionViewContentSize: CGSize{
         return CGSize(width: config.itemWidth, height: itemLastestY + config.itemHeight)
     }
     override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         return attributes
     }
     override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
         if indexPath.section == 0  {
             let headerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
             headerAttribute.frame = CGRect(x: 0, y: 0, width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: 64)
             return headerAttribute
         }
         return nil
     }
     override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
         
         
         
         let width = progressiveX * CGFloat(indexPath.item)
         let height = width
         itemLastestX -= progressiveX/2
         itemLastestY -= progressiveY
 //        if itemLastestX >= config.itemWidth/2 {itemLastestX = config.itemWidth/2}
         attribute.frame = CGRect(x: itemLastestX   , y: itemLastestY  - yOffsetPer * CGFloat(indexPath.item), width: width, height: height)
 //        let shortestYvalue = self.columns.min() ?? 0
 //        let shortestYvalueCol = self.columns.index(of: shortestYvalue)
 //        let columNum = shortestYvalueCol
 //        let x = self.edgeInsets.left + CGFloat(columNum ?? 0) * (width + self.columnMargin)
 //        let y = columns[columNum ?? 0]  + rowMargin
 //        self.columns[columNum ?? 0] = columns[columNum ?? 0] + height
 //        attribute.frame = CGRect(x: x , y: y , width: width, height: height)
         return attribute
     }
 }

 
 */
