//
//  UIView.swift
//  PDXTools
//
//  Created by Xingqun on 2024/1/18.
//

import UIKit

public extension UIView {
    /// 阴影
    func pdx_initShadowStyle() {
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowOpacity = 0.1
    }
    
    /// 设置指定圆角
    /// - Parameters:
    ///   - rectCorners: 需要显示的圆角
    ///   - cornerRadius: 圆角度数
    func pdx_setRoundedCorners(rectCorners:UIRectCorner,cornerRadius:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: rectCorners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
    }
    
    
    /// 设置指定边框
    /// - Parameters:
    ///   - rectCorners: 需要设置的位置
    ///   - color: 颜色
    func pdx_setBorderLayer(rectLines: UIRectEdge, color: UIColor) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        
        let line = 0.5
        if rectLines.contains(.top) {
            let topBorderLayer = CALayer()
            topBorderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: line)
            topBorderLayer.backgroundColor = color.cgColor
            self.layer.addSublayer(topBorderLayer)
        }
        
        if rectLines.contains(.bottom) {
            let bottomBorderLayer = CALayer()
            bottomBorderLayer.frame = CGRect(x: 0, y: self.frame.height - line, width: self.frame.width, height: line)
            bottomBorderLayer.backgroundColor = color.cgColor
            self.layer.addSublayer(bottomBorderLayer)
        }
        
        if rectLines.contains(.left) {
            borderLayer.frame = CGRect(x: 0, y: 0, width: line, height: self.frame.height)
            self.layer.addSublayer(borderLayer)
        }
        
        if rectLines.contains(.right) {
            borderLayer.frame = CGRect(x: self.frame.width - line, y: 0, width: line, height: self.frame.height)
            self.layer.addSublayer(borderLayer)
        }
    }
}
