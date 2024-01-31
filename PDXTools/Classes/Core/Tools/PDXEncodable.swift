//
//  PDXCommonProtocl.swift
//  PDXTools
//
//  Created by Xingqun on 2024/1/31.
//

import Foundation

/// 提供一些常用的model工具方法
public protocol PDXEncodable : Encodable {
    
}

public extension PDXEncodable {
    
    /// 将model转为Dictionary
    /// - Returns: Dictionary对象
    func toDictionary() -> [String : Any]  {
        let jsonEncoder = JSONEncoder()
        var dir : [String:Any]
        do {
            let userData = try jsonEncoder.encode(self)
            dir = try (JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any])!
        } catch {
            dir = [:]
        }
        
        return dir
    }
    
    /// 将对象转为字符串
    /// - Returns: 字符串
    func toString() -> String? {
        guard let data = self.toData() else{
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    /// 将对象转为Data
    /// - Returns: Data
    func toData() -> Data? {
        var data: Data?
        // 创建一个JSONEncoder对象
        let encoder = JSONEncoder()
        do {
            data = try encoder.encode(self)
        } catch {
            debugPrint("Error converting to data: \(error)")
        }
        return data
    }
}
