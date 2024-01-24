//
//  UIBarButtonItem.swift
//  SlowBoil
//
//  Created by BigSight on 2023/6/27.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import Foundation

import QMUIKit

public extension UIBarButtonItem {
    
    /// 创建右上角通知标志
    /// - Parameter imageName: 图标
    /// - Parameter sel: 跳转地址
    /// - Returns:UIBarButtonItem
    static func pdx_createBarbuttonItem(_ imageName:String, _ target: Any? , _ action:Selector?) -> UIBarButtonItem {
        let barbutItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: target, action: action)
        barbutItem.qmui_updatesIndicatorColor = UIColor.clear
        barbutItem.qmui_updatesIndicatorSize = CGSize(width: 7, height: 7)
        let point = barbutItem.qmui_updatesIndicatorOffset
        barbutItem.qmui_updatesIndicatorOffset = CGPoint(x: point.x - 6, y: point.y + 6)
        return barbutItem
    }
    
    /// 显示右上角通知标志红点
    /// - Parameter imageName: 红点图片
    func pdx_showBarButtonItemRedDot(_ imageName:String) {
        qmui_shouldShowUpdatesIndicator = true
        qmui_updatesIndicatorView?.addSubview(UIImageView(image: UIImage(named: imageName)))
    }
    
    /// 隐藏右上角通知标志红点
    func pdx_hiddenBarButtonItemRedDot() {
        qmui_shouldShowUpdatesIndicator = false
    }
}
