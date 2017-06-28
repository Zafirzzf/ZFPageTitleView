//
//  ZFContentView.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/10.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
public protocol ZFContentViewDelegate: class {
    func contentView(_ contentView: ZFContentView, targetIndex: Int, progress: CGFloat)
    func contentView(_ contentView: ZFContentView, endScroll Index: Int)
}



fileprivate let cellID = "cellID"
public class ZFContentView: UIView {
    weak var delegate: ZFContentViewDelegate?
    var isForbidDelegate: Bool = true // 防止点击标题触发滚动代理
    fileprivate var scrollStartOffSet: CGFloat = 0
    fileprivate let childVC: [UIViewController]
    fileprivate let parentVC: UIViewController
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false //点击状态栏到顶部
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(frame: CGRect, childControllers: [UIViewController], parentVC: UIViewController) {
        self.childVC = childControllers
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK:- 设置UI
extension ZFContentView {
    fileprivate func setupUI() {
        for childVc in childVC {
            parentVC.addChildViewController(childVc)
        }
        addSubview(collectionView)
    }
}

//MARK:- 数据源
extension  ZFContentView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVC.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        // 注意删除之前cell上的view
        _ = cell.contentView.subviews.map{ $0.removeFromSuperview() }
        
        let childView = childVC[indexPath.item].view!
        childView.frame = cell.contentView.bounds
        cell.contentView.addSubview(childView)
        
        
        return cell
    }
}

//MARK:- ScrollView 代理
extension ZFContentView: UICollectionViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        delegate?.contentView(self, endScroll:Int(scrollView.contentOffset.x / bounds.width))
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidDelegate { return }
        
        let offsetX = scrollView.contentOffset.x
        var targetIndex: Int
        var progress: CGFloat = 0
        if offsetX < scrollStartOffSet { //向左滑
            progress = (scrollStartOffSet - offsetX) / bounds.width
            targetIndex = Int(scrollStartOffSet / bounds.width) - 1
            if targetIndex < 0{
                targetIndex = 0
            }
        }else {
            progress = (offsetX - scrollStartOffSet) / bounds.width
            targetIndex = Int(scrollStartOffSet / bounds.width) + 1
            if targetIndex >= childVC.count {
                targetIndex = childVC.count - 1
            }
        }
      
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        scrollStartOffSet = scrollView.contentOffset.x
    }
}

//MARK:- 标题视图代理
extension ZFContentView: ZFTitleViewDelegate {
    func titleView(_ titleView: ZFTitleView, didSelected selectIndex: Int) {
        isForbidDelegate = true
        let targetIndexPath = IndexPath(item: selectIndex, section: 0)
        collectionView.scrollToItem(at: targetIndexPath, at: .left, animated: false)
    }
}


