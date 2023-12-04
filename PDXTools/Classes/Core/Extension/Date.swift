//
//  Date.swift
//  SlowBoil
//
//  Created by BigSight on 2023/7/7.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import Foundation

open extension Date {
    
    /// 根据格式转时间
    /// - Parameter format: 格式
    /// - Returns: 字符串
    open func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    /// 字符串转为时间。提供参数toDateFromCustom(dateString:"10:10","HH:mm"),应该返回本地时间2023-11-29 10:10:00
    /// - Parameters:
    ///   - customDate: 时间字符串
    ///   - customFormate: 时间格式
    /// - Returns: date
    open static func toDateFromCustom(dateString: String, _ format: String = "HH:mm") -> Date? {
        // 创建一个 DateFormatter 实例，用于解析时间部分
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = format
        
        return timeFormatter.date(from: dateString);
    }
    
    /// 字符串转为时间,补齐缺少时间。提供参数toDateFromCustom(dateString:"10:10","HH:mm"),应该返回本地时间2023-11-29 10:10:00，10-29 10:10 -> 2023-10-29 10:10:00
    /// - Parameters:
    ///   - customDate: 时间字符串
    ///   - customFormate: 时间格式
    /// - Returns: date
    open static func toDateFromCustomOfCompletionMissing(dateString: String, _ format: String = "HH:mm") -> Date? {
        // 获取当前日期和时间
        let currentDate = Date()
        
        // 创建一个 DateFormatter 实例，用于解析时间部分
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = format
        
        // 解析提供的时间部分
        guard let time = timeFormatter.date(from: dateString) else {
            return nil
        }
        
        // 使用 Calendar 和 DateComponents 创建一个完整的日期对象
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let combinedDate = calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                         minute: calendar.component(.minute, from: time),
                                         second: 0,
                                         of: calendar.date(from: components)!)
        
        return combinedDate
    }
    
    /// 转为：yyyy-MM-dd 字符串
    /// - Returns: 字符串
    open func toShortString() -> String {
        return toString("yyyy-MM-dd")
    }
    
    /// 转为：yyyy-MM-dd HH:mm:ss 字符串
    /// - Returns: 字符串
    open func toLongString() -> String {
        return toString("yyyy-MM-dd HH:mm:ss")
    }
    
    /// 获取secods后的时间字符串
    /// - Parameters:
    ///   - seconds: 指定秒后,正数为未来时间，负数为历史时间
    ///   - formate: 返回格式
    /// - Returns: 字符串
    open func toTimeStringAfterSeconds(seconds: Int,_ formate:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .second, value: seconds, to: currentDate)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formate
        
        if let futureDate = futureDate {
            let timeString = formatter.string(from: futureDate)
            return timeString
        } else {
            return ""
        }
    }
    
    /// 获取seconds后的时间对象
    /// - Parameter seconds: add seconds
    /// - Returns: date
    open func toTimeAfterSeconds(seconds: Int) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: seconds, to: currentDate) ?? Date()
    }
    
    /// 获取开始时间。let start = Date().toStartDate([.year,.month]).toLongString()
    /// - Parameter components: 当年的开始时间，月的开始，日的开始时间
    /// - Returns: date
    open func toStartDate(_ components: Set<Calendar.Component>) -> Date {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year,.month], from: now)
        let startOfYear = calendar.date(from: components) ?? Date()
        return startOfYear
    }
}
