//
//  String.swift
//  SlowBoil
//
//  Created by Lian on 2023/6/29.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import Foundation
import CommonCrypto

/// 字符串相关的工具操作
public extension String {
    /// md5加密：32位小写
    public var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    /// md5加密，16长度，小写。
    /// - Returns: <#description#>
    public func md5_lower_16() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let data = self.data(using: String.Encoding.utf8) {
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
        }
        
        // 将哈希值转为字符串
        let md5String = digest.reduce("") { (str, byte) -> String in
            return str + String(format: "%02x", byte)
        }
        
        // 返回16位MD5值（从第8位开始，截取16位）
        let startIndex = md5String.index(md5String.startIndex, offsetBy: 8)
        let endIndex = md5String.index(startIndex, offsetBy: 16)
        return String(md5String[startIndex..<endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - index: 下标
    ///   - length: 长度
    /// - Returns: 新字符串
    func subString(index:Int, length:Int) -> String? {
        let index = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(index, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        let substring = self[index..<endIndex]
        return String(substring)
    }
    
    /// 检查字符串是否为空,包括null,<NULL>,<null> 等。非String也是fale
    /// - Returns: 结果
    func isNotEmpty() -> Bool {
        return !self.isEmpty && self != "null" && self != "<NULL>" && self != "<null>"
    }
}

// 字符串的转换操作
public extension String {
    
    ///  html字符串->NSAttributedString
    func toHtmlAttributedText() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true) else
        { return nil }

        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [

            NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue,

            NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
        ]

        let htmlString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

        //this to have borders in html table

        htmlString?.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, 1))

        return htmlString

    }
    
    /// 转换data
    /// - Returns: data
    func toData() -> Data? {
        return self.data(using: .utf8)
    }
    
    /// 字符串转为对象
    /// - Returns: 对象
    func toObject<T: Decodable>(type:T.Type) -> T? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: jsonData)
            return object
        } catch {
            debugPrint("Failed to decode JSON: \(error)")
            return nil
        }
    }
    
    /// 字符串转为字典
    /// - Returns: 字典
    func toDictionary() -> [String: Any]? {
        if let jsonData = self.data(using: .utf8) {
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return jsonDict
                }
            } catch {
                debugPrint(error)
            }
        }
        return nil
    }
    
    /// 将字符串转为encodeURL的URL
    /// - Returns: URL
    func toEncodeURL() -> URL? {
        let newUrl = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if !newUrl.isNotEmpty() {
            return nil
        }
        
        if let urlComponents = URLComponents(string: newUrl),
           let encodedURL = urlComponents.url {
            return encodedURL
        }
        return nil
    }
    
    /// base64编码
    /// - Returns: string
    func toBase64Encoded() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
    
    /// base64解码
    /// - Returns: string
    func toBase64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
