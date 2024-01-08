//
//  PDXHelper.swift
//  PDXTools
//
//  Created by Xingqun on 2024/1/6.
//  Copyright © 2024 派大星. All rights reserved.
//

import Foundation

class PDXHelper: NSObject {
    
}

/// 网络相关
extension PDXHelper {
    /// 获得公网IP
    static func getPublicIP(backBlock: @escaping ((_ ipStr:String)->())){
        let queue = OperationQueue()
        let blockOP = BlockOperation.init {
            if let url = URL(string: "http://pv.sohu.com/cityjson?ie=utf-8") ,
                let s = try? String(contentsOf: url, encoding: String.Encoding.utf8) {
                debugPrint("data:\(s)")
                let subArr = s.components(separatedBy: ":")
                if subArr.count > 1  {
                    let ipStr = subArr[1].replacingOccurrences(of: "\"", with: "")
                    let ipSubArr = ipStr.components(separatedBy: ",")
                    if ipSubArr.count > 0 {
                        let ip = ipSubArr[0].trimmingCharacters(in: CharacterSet.whitespaces)
                        debugPrint("公网IP:\(ip)")
                        DispatchQueue.main.async {
                            backBlock(ip)
                        }
                        return
                    }
                }
            }else {
                debugPrint( "获得公网IP URL 转换失败")
            }
            backBlock("")
        }
        queue.addOperation(blockOP)
    }
}

/// 解码相关
extension PDXHelper {
    
}

/// 验证相关
extension PDXHelper {
    
    /// 验证密码，8~20位的中英文和数组
    /// - Parameter value: value
    /// - Returns: true 符合条件
    public static func verifyPassWord(_ value:String) -> Bool {
        
        let pattern = "^[A-Za-z0-9]{8,20}$"
        let pred  = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: self)
        if isMatch {
            return true
        }
        return false
    }
    
    
    /// 验证是否为邮箱
    /// - Parameter value: value
    /// - Returns: true 是邮箱
    public static func verifyEmail(_ value:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: value)
    }
}
