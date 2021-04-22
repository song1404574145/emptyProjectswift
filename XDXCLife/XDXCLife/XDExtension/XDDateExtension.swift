//
//  XDDateExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

extension Date {
    /// 是否是今天
    var isToday: Bool {
        return NSCalendar.current.isDateInToday(self)
    }
    /// 当前年份
    static var year: String {
        return XDDate.dateToString(date: Date(), formatter: "yyyy")
    }
    /// 上一年年份
    static var preYear: String {
        if let y = Int(year) {
            return "\(y - 1)"
        }
        
        return "2020"
    }
    /// 当前月份
    static var month: String {
        return XDDate.dateToString(date: Date(), formatter: "MM")
    }
}
