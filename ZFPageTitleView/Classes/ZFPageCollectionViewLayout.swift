//
//  ZFPageCollectionViewLayout.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/17.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

public class ZFPageCollectionViewLayout: UICollectionViewFlowLayout {

    fileprivate var attributes = [UICollectionViewLayoutAttributes]()
    var cols = 4
    var rows = 2
    fileprivate var maxWidth: CGFloat = 0
}

extension ZFPageCollectionViewLayout {
    override public func prepare() {
        super.prepare()
        
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        var PrePageCount = 0
        for j in 0 ..< collectionView!.numberOfSections {
            let itemCount = collectionView!.numberOfItems(inSection: j)
            for i in 0 ..< itemCount{
                let indexPath = IndexPath(item: i, section: j)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // 所在组的页数和下标
                let page = i / (cols * rows)
                let index = i % (cols * rows)
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                let itemX = sectionInset.left + CGFloat(index % cols) * (itemW + minimumInteritemSpacing) + CGFloat(page + PrePageCount) * collectionView!.bounds.width
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                attributes.append(attr)
            }
            PrePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        maxWidth = CGFloat(PrePageCount) * collectionView!.bounds.width
        
    }
}

extension ZFPageCollectionViewLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: collectionView!.bounds.height)
    }
}





