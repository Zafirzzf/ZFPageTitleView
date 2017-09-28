//
//  ZFPageStyle.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/10.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

public class ZFPageStyle: NSObject {
    open var titleViewBackColor = UIColor.white.withAlphaComponent(0.5)    /// 标题视图背景颜色
    open var collectionViewBackColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 248/255.0, alpha: 1)
    
    open var pageIndicatorTintColor = UIColor.gray
    
    open var currentPageIndicatorTintColor = UIColor.white
    
    open var titleViewHeight: CGFloat = 32     /// 标题视图高度

    open var scrollEnabled: Bool = true
    
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    open var fontTransformScale: CGFloat = 1.2  /// 标题放大时的比例

    open var titleMargin: CGFloat = 20   //标题之间的间距
    
    open var textNormalColor =  UIColor(red: 52/255.0, green: 53/255.0, blue: 54/255.0, alpha: 1)    /// 标题普通颜色
    
    open var textSelectColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 0, alpha: 1)   /// 标题选中颜色
    
    public convenience init(_ textNormalColor: UIColor, _ textSelectColor: UIColor, _ backColor: UIColor){
        self.init()
        self.textNormalColor = textNormalColor
        self.textSelectColor = textSelectColor
        self.titleViewBackColor = backColor
    }
    
    
    
}
