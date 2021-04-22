//
//  XDUIConfig.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation
import SwifterSwift

/// MARK: - UI 相关全局变量
/// 设备屏幕尺寸
var kScreenBounds: CGRect { return UIScreen.main.bounds }
/// 设备屏幕宽度
var kScreenWidth: CGFloat { return kScreenBounds.width }
/// 设备屏幕高度
var kScreenHeight: CGFloat { return kScreenBounds.height }

var kScale: CGFloat { return kScreenBounds.width / 375 }
/// 1像素
var kOnePixel: CGFloat { return 1 / UIScreen.main.scale }
/// 状态栏高度
var kStatusbarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }
/// 导航栏高度
var kNavbarHeight: CGFloat { return kStatusbarHeight + 44.0 }
/// Tabbar高度
var kTabbarHeight: CGFloat { return Int(UIApplication.shared.statusBarFrame.height) == 20 ? 49 : 83 }
/// 底部安全距离高度
var kSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let mainWindow = appDelegate.window {
            
            return mainWindow.safeAreaInsets
        }
    }
    
    return .zero
}
/// 底部安全距离高度
var kSafeAreaInsetsBottom: CGFloat {
    return kSafeAreaInsets.bottom
}

// MARK: - UIImage 相关
extension UIImage {
    /// 导航栏线的颜色
    static var navBarShadow: UIImage? {
        return UIColor(rgbValue: 0xf5f5f5).toImage()
    }
    /// 默认头像
    static var avatarDefault: UIImage? {
        return UIImage(named: "avatar_default")
    }
}

// MARK: - Font 相关
extension UIFont {
    /// 导航栏标题文本
    static var navBarTitle: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    /// 导航栏按钮文本
    static var navBarItem: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    /// tabbar 文本
    static var tabBar: UIFont {
        return UIFont.systemFont(ofSize: 10)
    }
    /// tabbar 选中文本
    static var tabBarSelect: UIFont {
        return UIFont.systemFont(ofSize: 10)
    }
}

/// MARK: - Color 相关
extension UIColor {
    /// 导航栏背景
    static var navBarBackground: UIColor {
        return UIColor(hex: 0xFFFFFF)!
    }
    static var navBarShadow: UIColor {
        return UIColor(hex: 0xE6E6E6)!
    }
    /// 导航栏标题
    static var navBarTitle: UIColor {
        return UIColor(hex: 0x300000)!
    }
    /// 导航栏按钮
    static var navBarItem: UIColor {
        return UIColor(hex: 0x333333)!
    }
    /// 导航栏按钮-禁用
    static var navBarItemDisable: UIColor {
        return UIColor(hex: 0x999999)!
    }
    /// tabbar背景
    static var tabBarBackground: UIColor {
        return UIColor(hex: 0xFFFFFF)!
    }
    static var tabBarShadow: UIColor {
        return tabBarBackground
    }
    /// tabbar默认
    static var tabBar: UIColor {
        return UIColor(hex: 0x808080)!
    }
    /// tabbar选中
    static var tabBarSelected: UIColor {
        return UIColor(hex: 0x00C293)!
    }
    
    /// 主题色
    static var themeYellow: UIColor {
        return UIColor(hex: 0xFBB000)!
    }
    /// 辅助色
    static var color0x438187: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .light {
                    return UIColor(hex: 0x438187)!
                } else {
                    return UIColor(hex: 0x438187)!
                }
            }
        }
        
        return UIColor(hex: 0x438187)!
    }
    /// 背景色
    static var color0xF5F5F5: UIColor {
        return UIColor(hex: 0xf5f5f5)!
    }
    
    /// 正文白色
    static var color0xFFFFFF: UIColor {
        return UIColor(hex: 0xFFFFFF)!
    }
    /// 正文纯黑
    static var color0x000000: UIColor {
        return UIColor(hex: 0x000000)!
    }
    /// 正文黑300000
    static var color0x300000: UIColor {
        return UIColor(hex: 0x300000)!
    }
    /// 正文黑1A1A1A
    static var color0x1A1A1A: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .light {
                    return UIColor(hex: 0x1A1A1A)!
                } else {
                    return UIColor(hex: 0x1A1A1A)!
                }
            }
        }
        
        return UIColor(hex: 0x1A1A1A)!
    }
    /// 灰 666666
    static var color0x666666: UIColor {
        return UIColor(hex: 0x666666)!
    }
    /// 正文中灰
    static var color0x808080: UIColor {
        return UIColor(hex: 0x808080)!
    }
    /// 分割线
    static var color0xE6E6E6: UIColor {
        return UIColor(hex: 0xE6E6E6)!
    }
    /// 红 DC3046
    var colorOxdc3046: UIColor {
        return UIColor(hex: 0xDC3046)!
    }
    /// 红 DC3046
    var colorOxf2263f: UIColor {
        return UIColor(hex: 0xF2263F)!
    }
    /// 不可用背景色
    static var color0xCCCCCC: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .light {
                    return UIColor(hex: 0xCCCCCC)!
                } else {
                    return UIColor(hex: 0xCCCCCC)!
                }
            }
        }
        
        return UIColor(hex: 0xCCCCCC)!
    }
    /// 橙色 F97847
    static var color0xf97847: UIColor {
        return UIColor(hex: 0xF97847)!
    }
    /// 背景遮罩
    static var maskBackground: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }
    
    /// 文本框占位文本颜色
    static var textFieldPlaceholder: UIColor {
        return UIColor(hex: 0xAFAFAF)!
    }
//
//    /// 性别男
//    static var sexBoy: UIColor {
//        return UIColor(hex: 0x4CC3FF)!
//    }
//    /// 性别女
//    static var sexGirl: UIColor {
//        return UIColor(hex: 0xF65B5B)!
//    }
}
