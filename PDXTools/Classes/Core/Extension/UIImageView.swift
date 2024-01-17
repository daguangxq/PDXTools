//
//  UIImageView.swift
//  SlowBoil
//
//  Created by BigSight on 2023/8/23.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import UIKit
import QMUIKit
import Kingfisher

extension UIImageView {
    
    private struct AssociatedKeys {
        static var activityIndicator = "activityIndicator"
    }

    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func startIndicator() {
        if activityIndicator == nil {
            if #available(iOS 13.0, *) {
                activityIndicator = UIActivityIndicatorView(style: .medium)
            } else {
                activityIndicator = UIActivityIndicatorView(style: .white)
            }
            activityIndicator?.color = .gray
            activityIndicator?.hidesWhenStopped = true

            if let indicator = activityIndicator {
                addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                    indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
        }

        activityIndicator?.startAnimating()
    }

    private func stopIndicator() {
        activityIndicator?.stopAnimating()
    }
    
    /// 图片下载，灰色占位图
    /// - Parameter url: 下载地址
    public func pdx_setImageURLWithGrayPlaceholder(with url:URL?) {
        guard let url = url else { return }
        
        let placeholder = UIImage.qmui_image(with: UIColor.qmui_color(withHexString: "#F2F2F2"))
        self.kf.setImage(with: url,placeholder: placeholder)
    }
    
    /// 图片下载，菊花进度条
    /// - Parameter url: 下载地址
    public func pdx_setImageURLWithIndicator(with url:URL?) {
        guard let url = url else { return }
        self.startIndicator()
        self.kf.setImage(with: url) {[weak self] (_) in
            self?.stopIndicator()
        }
    }
}
