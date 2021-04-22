//
//  XDAppConfig+notifi.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation
import UIKit

let XDNotifiCenter = NotificationCenter.default

extension NSNotification.Name {
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
    
    /// app 更新
    static let appVersionRefresh        = NSNotification.Name("appVersionRefresh")
    /// 用户登录
    static let userDidLogin             = NSNotification.Name("userDidLogin")
    /// 用户信息更新
    static let userInfoUpdate           = NSNotification.Name("userInfoUpdate")
    /// 用户退出登录
    static let userDidLogout            = NSNotification.Name("userDidLogout")
    /// 定位权限开启
    static let locationManagerDidChangeStatus_open = Notification.Name("LocationManagerDidChangeStatus_open")
    /// 定位更新
    static let locationManagerDidChange = Notification.Name("locationManagerDidChange")
    /// 网络错误
    static let networkError             = Notification.Name("networkError")
    /// 网络断开链接
    static let networkDisconnect    = Notification.Name("networkDisconnect")
    /// 网络恢复链接
    static let networkConnect       = Notification.Name("networkConnect")
}

