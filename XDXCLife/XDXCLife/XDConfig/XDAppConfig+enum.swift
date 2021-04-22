//
//  XDAppConfig+enum.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//
/**
 *  @author oy
 *
 *  @classBrief 常用公共枚举
 *
 */

import Foundation

extension XDAppConfig {
    
    /// Window 视图层级
    enum WindowLevel: Int {
        case level10 = 1100
        case level20 = 1200
        case level30 = 1300
        /// AutoAlert  LoadingView
        case level40 = 1400
        /// 全屏动画  更新界面
        case level50 = 1500
        /// 广告
        case level60 = 1600
    }
    
    /// 发送短信验证码类型
    enum SendCodeType: Int {
        case login = 1
        case register = 2
        case resetPassword = 3
        case resetPhone = 4
    }
    
    /// 其他待加
    
}
