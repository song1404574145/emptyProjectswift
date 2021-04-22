//
//  XDAppConfig.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation
import UIKit

struct XDAppConfig {
    private init() {}
    
    
    /// 开发组id
    static let teamID = ""
    /// Appid
    static let appId = ""
    /// App Store下载地址
    static let appStoreURL = "https://itunes.apple.com/cn/app/id\(appId)?mt=8"
    /// App Store评论地址
    static let commentAppURL = appStoreURL + "&action=write-review"
    /// 安卓、iOS通用下载地址
    static let appURL = ""
//    static let appEnvironment =
    /// 手机系统版本
    static let iOSVersion = UIDevice.current.systemVersion
    /// 设备UUID
    static let identfierNumber = UIDevice.current.identifierForVendor
    /// 设备名称
    static let systemName = UIDevice.current.systemName
    /// 包名
    static let bunleIdentifier = Bundle.main.bundleIdentifier
    /// app 配置文件
    static let infoDictionary = Bundle.main.infoDictionary
    /// App 名字
    static let appDisplayName = infoDictionary!["CFBundleDisplayName"] as? String ?? infoDictionary!["CFBundleName"] as? String ?? ""
    /// App 版本号
    static let appVersion = infoDictionary!["CFBundleShortVersionString"] as! String
    /// App build 版本号
    static let buildVersion = infoDictionary!["CFBundleVersion"] as! String
    /// 是否是iPhone X系列
    static let isIPhoneXSeries = isIPhoenXSeriesF()
    /// 是否是iPhone
    static let isIPhone = UIDevice.current.model == "iPhone"
}

extension XDAppConfig {
    
    /// 判断是否是刘海机
    /// - Returns: <#description#>
    private static func isIPhoenXSeriesF() -> Bool {
        var iPhoneXSeries = false
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            return iPhoneXSeries
        }
        
        if #available(iOS 11.0, *) {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let mainWindow = appDelegate.window, mainWindow.safeAreaInsets.bottom > 0.0 {
                iPhoneXSeries = true
            }
        } else {
            if UIScreen.main.bounds.size.height > 812 {
                iPhoneXSeries = true
            }
        }
        return iPhoneXSeries
    }
}

extension XDAppConfig {
    
    /// Int转汉字
    /// - Parameters:
    ///   - number: 数字
    ///   - numberStyle: 类型
    /// - Returns: 汉字
    static func intIntoString(number: Int, numberStyle: NumberFormatter.Style = .spellOut) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh-cn")
        formatter.numberStyle = numberStyle
        let string: String = formatter.string(from: NSNumber(value: number))!
        return string
    }
}
