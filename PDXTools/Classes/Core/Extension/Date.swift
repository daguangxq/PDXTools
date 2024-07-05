//
//  Date.swift
//  SlowBoil
//
//  Created by BigSight on 2023/7/7.
//  Copyright © 2023 daguangxq@icloud.com. All rights reserved.
//

import Foundation

extension Date {
    
    /// 根据格式转时间
    /// - Parameter format: 格式
    /// - Returns: 字符串
    public func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .init(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
    
    /// 字符串转为时间。提供参数toDateFromCustom(dateString:"10:10","HH:mm"),应该返回本地时间2023-11-29 10:10:00
    /// - Parameters:
    ///   - customDate: 时间字符串
    ///   - customFormate: 时间格式
    /// - Returns: date
    public static func toDateFromCustom(dateString: String, _ format: String = "HH:mm") -> Date? {
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
    public static func toDateFromCustomOfCompletionMissing(dateString: String, _ format: String = "HH:mm") -> Date? {
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
    public func toShortString() -> String {
        return toString("yyyy-MM-dd")
    }
    
    /// 转为：yyyy-MM-dd HH:mm:ss 字符串
    /// - Returns: 字符串
    public func toLongString() -> String {
        return toString("yyyy-MM-dd HH:mm:ss")
    }
    
    /// 获取secods后的时间字符串
    /// - Parameters:
    ///   - seconds: 指定秒后,正数为未来时间，负数为历史时间
    ///   - formate: 返回格式
    /// - Returns: 字符串
    public func toTimeStringAfterSeconds(seconds: Int,_ formate:String = "yyyy-MM-dd HH:mm:ss") -> String {
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
    public func toTimeAfterSeconds(seconds: Int) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: seconds, to: currentDate) ?? Date()
    }
    
    /// 获取开始时间。let start = Date().toStartDate([.year,.month]).toLongString()
    /// - Parameter components: 当年的开始时间，月的开始，日的开始时间
    /// - Returns: date
    public func toStartDate(_ components: Set<Calendar.Component>) -> Date {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year,.month], from: now)
        let startOfYear = calendar.date(from: components) ?? Date()
        return startOfYear
    }
}


extension Date {
    
    /// 根据时间戳转换为指定格式的日期字符串
    /// - Parameters:
    ///   - timestamp: 时间戳，表示从 1970 年 1 月 1 日 00:00:00 UTC 到指定时间的秒数
    ///   - formatter: 日期格式字符串，用于格式化日期，例如："yyyy-MM-dd HH:mm:ss"
    /// - Returns: 格式化后的日期字符串
    public static func formatDateFromTimestamp(_ timestamp: TimeInterval,formatter:String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: date)
    }
}
