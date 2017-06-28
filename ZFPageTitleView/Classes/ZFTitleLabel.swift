//
//  ZFTitleLabel.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/10.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

class ZFTitleLabel: UILabel {
    var style: ZFPageStyle
    var select: Bool = false {
        didSet {
            if select {
                textColor = style.textSelectColor
                transformAnimateToScale(style.fontTransformScale)
            }else {
                textColor = style.textNormalColor
                transformAnimateToScale(1.0)
            }
        }
    }
    
    
    init(style: ZFPageStyle) {
        self.style = style
        super.init(frame: CGRect())
        textAlignment = .center
        isUserInteractionEnabled = true
        textColor = style.textNormalColor
        font = style.titleFont

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func transformAnimateToScale(_ toScale: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: { 
            self.transformScale(scale: toScale )
        })
    }
    func transformScale(scale: CGFloat) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }

}
