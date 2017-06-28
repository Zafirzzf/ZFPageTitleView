//
//  ZFPageStyle.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/10.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

public class ZFPageStyle: NSObject {
    var titleViewBackColor = UIColor.white.withAlphaComponent(0.5)    /// 标题视图背景颜色
    
    var collectionViewBackColor = UIColor(colorLiteralRed: 246/255.0, green: 246/255.0, blue: 248/255.0, alpha: 1)
    
    var pageIndicatorTintColor = UIColor.gray
    
    var currentPageIndicatorTintColor = UIColor.white
    
    var titleViewHeight: CGFloat = 32     /// 标题视图高度

    var scrollEnabled: Bool = true
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    var fontTransformScale: CGFloat = 1.2  /// 标题放大时的比例

    var titleMargin: CGFloat = 20   //标题之间的间距
    
    var textNormalColor =  UIColor(colorLiteralRed: 52/255.0, green: 53/255.0, blue: 54/255.0, alpha: 1)    /// 标题普通颜色
    
    var textSelectColor = UIColor(colorLiteralRed: 255/255.0, green: 127/255.0, blue: 0, alpha: 1)   /// 标题选中颜色
    
    convenience init(_ textNormalColor: UIColor, _ textSelectColor: UIColor, _ backColor: UIColor){
        self.init()
        self.textNormalColor = textNormalColor
        self.textSelectColor = textSelectColor
        self.titleViewBackColor = backColor
    }
    
    
    
}
