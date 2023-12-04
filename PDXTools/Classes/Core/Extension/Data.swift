//
//  Data.swift
//  SlowBoil
//
//  Created by BigSight on 2023/7/8.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import Foundation

open extension Data {
    
    /// 将data转为对象
    /// - Returns: 被转对象
    open func toObject<T:Decodable>(type:T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type , from: self)
            return object
        } catch {
            debugPrint("Error decoding data: \(error)")
        }
        return nil
    }
    
    /// 将Data转为String
    /// - Returns: 被转后的字符串
    open func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    
    /// 转为字典
    /// - Returns:字典
    open func toDictionary() -> [String: Any]? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            debugPrint("Error converting data to dictionary: \(error)")
        }
        return nil
    }
}
