//
//  XDUtils.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

struct XDUtils {
    private init() {}
    
    /// 关闭键盘
    static func dismissKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }
    
    /// 复制文本
    /// - Parameter text: 文本
    static func copy(text: String?) {
        let past = UIPasteboard.general
        past.string = text
    }
}

// MARK: - openURL
extension XDUtils {
    @discardableResult
    static func openURL(_ url: URL) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: nil)
            return true
        }
        return false
    }
    
    /// 打开APP设置页面
    @discardableResult
    static func openSetting() -> Bool {
        return openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    /// 拨打电话
    @discardableResult
    static func call(phone: String) -> Bool {
        if let url = URL(string: "tel:\(phone)") {
            return openURL(url)
        }
        
        return false
    }
}

// MARK: - UI 部分
extension XDUtils {
    /// 添加 视图到 window
    static func windowAdd(subview view: UIView, level: XDAppConfig.WindowLevel) {
        var aboveView: UIView? = nil
        
        if let subviews = appDelegate?.window?.subviews {
            for subview in subviews {
                if subview.tag > level.rawValue {
                    break
                } else {
                    aboveView = subview
                }
            }
        }
        
        view.tag = level.rawValue
        
        if let aboveView = aboveView {
            appDelegate?.window?.insertSubview(view, aboveSubview: aboveView)
        } else {
            appDelegate?.window?.addSubview(view)
        }
    }
    
    /// 删除 window 上所有 YLWindowLevel
    static func removeLevelSubviews() {
        appDelegate?.window?.subviews.forEach {
            if $0.tag >= XDAppConfig.WindowLevel.level10.rawValue {
                $0.removeFromSuperview()
            }
        }
    }
    
    /// 获取 appDelegate
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    /// 获取当前的导航栏
    ///
    /// - Returns: 当前的导航栏
    static var currentNav: UINavigationController? {
        return currentVC?.navigationController
    }
    
    /// 获取当前显示的VC
    ///
    /// - Returns: 当前屏幕显示的VC
    static var currentVC: UIViewController? {
        // 获取当先显示的window
        var currentWindow = UIApplication.shared.keyWindow
        
        if currentWindow?.windowLevel != UIWindow.Level.normal {
            let windowArr = UIApplication.shared.windows
            
            for window in windowArr {
                if window.windowLevel == UIWindow.Level.normal {
                    currentWindow = window
                    break
                }
            }
        }
        
        if let currentWindow = currentWindow {
            return getNextVC(nextController: currentWindow.rootViewController)
        }
        
        return nil
    }
    
    private static func getNextVC(nextController: UIViewController?) -> UIViewController? {
        if nextController == nil {
            return nil
        } else if nextController?.presentedViewController != nil {
            return getNextVC(nextController: nextController?.presentedViewController)
        } else if let tabbar = nextController as? UITabBarController {
            return getNextVC(nextController: tabbar.selectedViewController)
        } else if let nav = nextController as? UINavigationController {
            return getNextVC(nextController: nav.visibleViewController)
        }
        return nextController
    }
}

// MARK: - BRPickerView
import BRPickerView
extension XDUtils {
    @discardableResult
    static func pickerViewWithSingle(title: String, data: [String], autoShow: Bool = true, handle: @escaping ((Int) -> Void)) -> BRStringPickerView {
        let view = BRStringPickerView()
        view.pickerMode = .componentSingle
        view.title = title
        view.dataSourceArr = data
        
        view.resultModelBlock = { (data) in
            if let index = data?.index {
                handle(index)
            }
        }
        
        if autoShow {
            view.show()
        }
        
        return view
    }
}
