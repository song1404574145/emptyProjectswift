//
//  XDDate.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

struct XDDate {
    private init() {}
    
    private static var dateFormatter = DateFormatter()
    
    /// NSDate 转时间戳
    static func datetoTime(date: Date?) -> String {
        if let time = date?.timeIntervalSince1970 {
            return "\(Int(time))000"
        }
        
        return "0"
    }
    
    /// 时间戳13位 转 2018-10-22
    static func timeToDate(time: String, formatter: String) -> String {
        let timeInterval = time.timeInterval
        
        dateFormatter.dateFormat = formatter
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
    
    /// Date 转 2018-10-22
    static func dateToString(date: Date, formatter: String) -> String {
        dateFormatter.dateFormat = formatter
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    /// 2018-10-22 转 时间戳 时间戳13位
    static func dateToTime(dateStr: String, formatter: String) -> String {
        dateFormatter.dateFormat = formatter
        
        if let date = dateFormatter.date(from: dateStr) {
            let time = date.timeIntervalSince1970
            return "\(Int(time))000"
        }
        
        return ""
    }
    
    /// 获取当前时间戳 时间戳13位
    static func currentTime() -> String {
        let time = Date().timeIntervalSince1970
        return "\(Int(time))000"
    }
    
    /// 倒计时 时间戳13位
    static func countdown(_ endTime: String) -> String {
        let endTimeInterval = endTime.timeInterval
        
        // 未来时间
        let endDate = Date(timeIntervalSince1970: endTimeInterval)
        // 现在时间
        let nowDate = Date()
        let calendar = Calendar.current
        let commponent = calendar.dateComponents([.day,.hour,.minute,.second], from: nowDate, to: endDate)
        
        var dateStr = ""
        
        if let day = commponent.day,
           day != 0 {
            dateStr = "\(String(describing: day)) " + "天"
        }
        
        if let hour = commponent.hour,
           hour != 0 {
            dateStr = "\(String(describing: hour)) " + "小时"
        }
        
        if let minute = commponent.minute,
           minute != 0 {
            dateStr += "\(String(describing: minute)) " + "分钟"
        }
        
        if let second = commponent.second,
           second != 0 {
            dateStr += "\(String(describing: second)) " + "秒"
        }
        
        return dateStr
    }
    
    /// 计时 type 0 显示分  1 显示时
    static func timer(_ startTime: String, type: Int) -> String {
        let startTimeInterval = startTime.timeInterval
        
        // 开始时间
        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        // 现在时间
        let nowDate = Date()
        let calendar = Calendar.current
        let commponent = calendar.dateComponents([.hour,.minute,.second], from: startDate, to: nowDate)
        
        var dateStr = ""
        
        if type == 1 {
            if let hour = commponent.hour,
               hour != 0 {
                
                if hour < 10 {
                    dateStr = "0\(String(describing: hour)):"
                } else {
                    dateStr = "\(String(describing: hour)):"
                }
            } else {
                dateStr = "00:"
            }
        }
        
        if let minute = commponent.minute,
           minute != 0 {
            
            if minute < 10 {
                dateStr += "0\(String(describing: minute)):"
            } else {
                dateStr += "\(String(describing: minute)):"
            }
        } else {
            dateStr += "00:"
        }
        
        if let second = commponent.second,
           second != 0 {
            
            if second < 10 {
                dateStr += "0\(String(describing: second))"
            } else {
                dateStr += "\(String(describing: second))"
            }
        } else {
            dateStr += "00"
        }
        
        return dateStr
        
    }
}
