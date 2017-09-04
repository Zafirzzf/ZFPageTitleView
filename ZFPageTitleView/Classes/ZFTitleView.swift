//
//  ZFTitleView.swift
//  ZFPageView
//
//  Created by 周正飞 on 17/5/10.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

public protocol ZFTitleViewDelegate: class{
    func titleView(_ titleView: ZFTitleView, didSelected selectIndex: Int)
}

public class ZFTitleView: UIView {
   open  weak var delegage: ZFTitleViewDelegate?
    public var style = ZFPageStyle()


    fileprivate var titles: [String]
    fileprivate var titleLabels = [ZFTitleLabel]()
    var selectIndex = 0 {
        didSet {
            if (oldValue == selectIndex) { return }
            titleLabels[oldValue].select = false
            titleLabels[selectIndex].select = true
        }
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    public init(frame: CGRect, style: ZFPageStyle, titles: [String]) {

        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- 设置界面
extension ZFTitleView {
    fileprivate func setupUI() {
        
        //滑动视图
        setupScroll()
        
        //标题label
        setupTitleLabels()
        
        //标题label的布局
        setupLabelsFrame()

    }
    private func setupScroll() {
        
        scrollView.backgroundColor = style.titleViewBackColor
        scrollView.isScrollEnabled = style.scrollEnabled
        addSubview(scrollView)
    }
    
    private func setupTitleLabels() {
        for (i,title) in titles.enumerated() {
            let label = ZFTitleLabel(style: style)
            label.text = title
            label.tag = i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(gesture:))))
            titleLabels.append(label)
            scrollView.addSubview(label)
        }
    }
    
    /// 布局
    private func setupLabelsFrame() {
        let labelMargin = style.titleMargin
        var labelX: CGFloat = labelMargin
        
        for (i, label) in titleLabels.enumerated() {
            if style.scrollEnabled {
                let titleWidth = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.titleFont], context: nil).width
                
                let rect = CGRect(x: labelX, y: 0, width: titleWidth, height: bounds.height)
                labelX += titleWidth + labelMargin
                label.frame = rect
            }else {
                let labelW: CGFloat = bounds.width / CGFloat(titleLabels.count)
                let rect = CGRect(x: labelW * CGFloat(i), y: 0, width: labelW, height: bounds.height)
                label.frame = rect
            }
      
            
            
            if i == titles.count - 1 {
                scrollView.contentSize = CGSize(width: label.frame.maxX + labelMargin, height: bounds.height)
            }
            
        }
        //如果标题总长度不足屏幕宽,调整到居中
        if scrollView.contentSize.width < bounds.width {
            scrollView.isScrollEnabled = false
            let labelW = frame.width / CGFloat(titleLabels.count)
            var newLabelX: CGFloat = 0
            for label in titleLabels {
                let rect = CGRect(x: newLabelX, y: 0, width: labelW, height: bounds.height)
                label.frame = rect
                newLabelX += labelW 
            }
        }

        
        titleLabels[0].select = true // 第一个选中
    }
    
    
}

//MARK:- 事件响应
extension ZFTitleView {
    @objc fileprivate func titleLabelClick(gesture: UITapGestureRecognizer) {
        let selectLabel = gesture.view as? ZFTitleLabel
        guard let select = selectLabel else { return }
        setScrollInset(select)
        selectIndex = select.tag // 切换label属性
        delegage?.titleView(self, didSelected: select.tag) // 触发代理
    }
    
    fileprivate func setScrollInset(_ label: UILabel){
        guard scrollView.isScrollEnabled else { return }
        let labelX = label.center.x
        var offsetX = labelX - bounds.width / 2
      
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        if offsetX < 0 {
            offsetX = 0
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK:- ZFContentView滑动代理
extension ZFTitleView: ZFContentViewDelegate {
    public func contentView(_ contentView: ZFContentView, endScroll Index: Int) {

        selectIndex = Index
        //调整位置
        setScrollInset(titleLabels[selectIndex])
     
      
        
    }
    public func contentView(_ contentView: ZFContentView, targetIndex: Int, progress: CGFloat) {

        if progress > 0.9 {
            selectIndex = targetIndex
            //调整位置
            setScrollInset(titleLabels[selectIndex])
        }
        
        let fonttransformScale = style.fontTransformScale
        let oldLabelScale = fonttransformScale - (fonttransformScale - 1) * progress
        let targetLabelScale = 1 + (fonttransformScale - 1) * progress
        let oldLabel = titleLabels[selectIndex]
        let newLabel = titleLabels[targetIndex]
        
        // 滑动过程中缩放字体
        oldLabel.transformScale(scale: oldLabelScale)
        newLabel.transformScale(scale: targetLabelScale)
        
        // 改变字体颜色
        let normalColor = getRGBValue(style.textNormalColor)
        let selectColor = getRGBValue(style.textSelectColor)
        let excessColor = (selectColor.0 - normalColor.0,
                           selectColor.1 - normalColor.1,
                           selectColor.2 - normalColor.2)
        
        oldLabel.textColor = UIColor(red: (selectColor.0 - excessColor.0 * progress) / 255.0,
                                     green: (selectColor.1 - excessColor.1 * progress) / 255.0,
                                     blue: (selectColor.2 - excessColor.2 * progress) / 255.0,
                                     alpha: 1)
        newLabel.textColor = UIColor(red: (normalColor.0 + excessColor.0 * progress) / 255.0,
                                     green: (normalColor.1 + excessColor.1 * progress) / 255.0,
                                     blue: (normalColor.2 + excessColor.2 * progress) / 255.0,
                                     alpha: 1)
    
        
    }
    
    
    func getRGBValue(_ color: UIColor) ->(CGFloat,CGFloat,CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB设置")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

