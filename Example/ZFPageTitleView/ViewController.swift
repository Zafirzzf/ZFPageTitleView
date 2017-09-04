//
//  ViewController.swift
//  ZFPageTitleView
//
//  Created by Zafirzzf on 06/28/2017.
//  Copyright (c) 2017 Zafirzzf. All rights reserved.
//

import UIKit
import ZFPageTitleView
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var childVCs = [UIViewController]()
        for _ in 0 ..< 4 {
            let testVC = UIViewController()
            testVC.view.backgroundColor = UIColor.randomColor()
            childVCs.append(testVC)
        }
        let style = ZFPageStyle()
        let pageView = ZFPageView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40), titles: ["推荐","热门","关注","发现"], childControllers: childVCs, parentVC: self)
        view.addSubview(pageView)
    }


}

