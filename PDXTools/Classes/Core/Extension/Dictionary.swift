//
//  Dictionary.swift
//  PDXTools
//
//  Created by Xingqun on 2024/1/6.
//  Copyright © 2024 派大星. All rights reserved.
//

import Foundation


public extension Dictionary {
    
    /// 字典转Data,类型默认为prettyPrinted
    /// - Returns: data
    func toData(_ type:JSONSerialization.WritingOptions = [.prettyPrinted]) -> Data? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            debugPrint("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        debugPrint("params:\(str!)")
        return data
    }
}
