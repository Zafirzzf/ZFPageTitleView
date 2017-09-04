//
//  ZFPageCollectionView.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/16.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

@objc protocol ZFPageCollectionViewDataSource: class  {
    func numberOfSections(in collectionView: ZFPageCollectionView) -> Int
    func collectionView(_ collectionView: ZFPageCollectionView, numberOfItemsInSection section: Int) -> Int
   @objc optional func collectionView(_ pageCollectionView: ZFPageCollectionView,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
@objc protocol ZFPageCollectionViewDelegate: class {
   @objc optional func collectionView(_ pageCollectionView: ZFPageCollectionView, _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

public class ZFPageCollectionView: UIView {
    weak var dataSource: ZFPageCollectionViewDataSource?
    weak var delegate: ZFPageCollectionViewDelegate?
    fileprivate var titles = [String]()
    fileprivate var style: ZFPageStyle
    fileprivate let layout: ZFPageCollectionViewLayout
    fileprivate let isTitleInTop: Bool
    fileprivate var currentIndexPath = IndexPath(item: 0, section: 0)
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var titleView: ZFTitleView!
    public init(frame: CGRect, titles: [String], style: ZFPageStyle, isTitleInTop: Bool, layout: ZFPageCollectionViewLayout) {

        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        super.init(frame: frame)

        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK:- 设置UI
extension ZFPageCollectionView {
    fileprivate func setupUI() {
        // 1. titleView
        let titleViewH = style.titleViewHeight
        let titleY = isTitleInTop ? 0 : bounds.height - titleViewH
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: titleViewH)
        titleView = ZFTitleView(frame: titleFrame,
                                    style: style,
                                    titles: titles)
        titleView.backgroundColor = style.titleViewBackColor
        titleView.delegage = self
        addSubview(titleView)
        
        //2. pageControl
        let pageControlH: CGFloat = 20
        let pageControlY = isTitleInTop ? bounds.height - pageControlH : bounds.height - pageControlH - titleViewH
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlH))
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = style.pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = style.currentPageIndicatorTintColor
        pageControl.backgroundColor = style.collectionViewBackColor
        addSubview(pageControl)
        
        //3. collectionView
        let collectionY: CGFloat = isTitleInTop ? titleViewH : 0
        let coFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - pageControlH - titleViewH)
        collectionView = UICollectionView(frame: coFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = style.collectionViewBackColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        
    }
}
//MARK:- 提供给外部的函数
extension ZFPageCollectionView {
    func register(cellClass: AnyClass?, identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier )
    }
    func register(nib: UINib?, identifier: String){
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    func reloadData() {
        collectionView.reloadData()
    }
}

//MARK:- 数据源
extension ZFPageCollectionView:  UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            updatePageControl(section: section)
        }
        return itemCount
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dataSource?.collectionView!(self, collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }

}

//MARK:- 滑动点击事件响应
extension ZFPageCollectionView: UICollectionViewDelegate, ZFTitleViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView!(self, collectionView, didSelectItemAt: indexPath)
    }
    
    // 调整PageControl
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
      
    }
    // 滚动完毕后的处理
    fileprivate func scrollViewEndScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
        //判断组是否发生改变
        if currentIndexPath.section != indexPath.section {
            currentIndexPath = indexPath
            updatePageControl(section: indexPath.section)
            pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
            //改变titleView
            titleView.selectIndex = indexPath.section
        }
    }
    // 点击了标题
    public func titleView(_ titleView: ZFTitleView, didSelected selectIndex: Int) {

        let indexPath = IndexPath(item: 0, section: selectIndex)
        currentIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        if selectIndex != titles.count - 1 {
            collectionView.contentOffset.x -= layout.sectionInset.left
        }
        updatePageControl(section: selectIndex)
        
    }
    
    
    
    // 更新pageControl
    fileprivate func updatePageControl(section: Int) {
        let itemCount =  dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0
        pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
    }

   
}




