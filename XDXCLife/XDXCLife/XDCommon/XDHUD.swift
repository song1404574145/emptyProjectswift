//
//  XDHUD.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import Foundation
import MCToast

struct XDHUD {
    private init() {}
    
    static func toast(_ text: String? = nil, isUserInteraction: Bool = true, showTime: CGFloat? = nil) {
        if let showTime = showTime {
            MCToast.mc_text(text ?? "", duration: showTime, respond: isUserInteraction ? .respond : .navBarRespond)
        } else {
            MCToast.mc_text(text ?? "", respond: isUserInteraction ? .respond : .navBarRespond)
        }
    }
    
    /// 菊花加载
    /// - Parameter isUserInteraction: 是否有交互
    static func loading(isUserInteraction: Bool = false) {
        MCToast.mc_loading(text: "", respond: isUserInteraction ? .respond : .navBarRespond, callback: nil)
    }
    
    /// 关闭HUD
    static func closeHUD() {
        MCToast.mc_remove()
    }
    
    static func alert(title: String? = nil ,msg: String? = nil, btnTitles: [String], sourceView: UIView? = nil, config: ((UIAlertController) -> Void)? = nil, callback: ((_ index: Int, _ title: String) -> Void)? = nil) {
        DispatchQueue.main.async {
            XDHUD.closeHUD()
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            config?(alert)
            
            if let subView = alert.view.subviews.first,
               let subSubView = subView.subviews.first {
                subSubView.backgroundColor = .white
                subSubView.layer.cornerRadius = 15
            }
            
            if let _title = title {
                let attributedString = NSMutableAttributedString(string: _title)
                attributedString.addAttribute(.foregroundColor, value: UIColor.color0x1A1A1A, range: NSRange(location: 0, length: _title.count))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: _title.count))
                
                alert.setValue(attributedString, forKey: "attributedTitle")
            }
            
            if let _msg = msg {
                let attributedString = NSMutableAttributedString(string: _msg)
                attributedString.addAttribute(.foregroundColor, value: UIColor.color0x300000, range: NSRange(location: 0, length: _msg.count))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: _msg.count))
                
                alert.setValue(attributedString, forKey: "attributedMessage")
            }
            
            for i in 0...btnTitles.count - 1 {
                let title = btnTitles[i]
                
                let titleAction = UIAlertAction(title: title, style: .default) { (action) in
                    callback?(i, title)
                }
                
                if btnTitles.count == 1 {
                    titleAction.setValue(UIColor.themeYellow, forKey: "titleTextColor")
                } else if btnTitles.count == 2 {
                    if i == 0 {
                        titleAction.setValue(UIColor.color0x666666, forKey: "titleTextColor")
                    } else {
                        titleAction.setValue(UIColor.themeYellow, forKey: "titleTextColor")
                    }
                } else {
                    titleAction.setValue(UIColor.color0x666666, forKey: "titleTextColor")
                }
                
                alert.addAction(titleAction)
            }
            
            if let vc = XDUtils.currentVC {
                if XDAppConfig.isIPhone {
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                } else {
                    let popPresenter = alert.popoverPresentationController
                    popPresenter?.sourceView = sourceView ?? vc.view
                    popPresenter?.sourceRect = sourceView?.bounds ?? vc.view.bounds
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    static func actionSheet(title: String? = nil ,msg: String? = nil, btnTitles: [String], sourceView: UIView? = nil, callback: ((_ index: Int, _ title: String) -> Void)? = nil) {
        DispatchQueue.main.async {
            XDHUD.closeHUD()
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if let _msg = msg {
                let attributedString = NSMutableAttributedString(string: _msg)
                attributedString.addAttribute(.foregroundColor, value: UIColor.color0x300000, range: NSRange(location: 0, length: _msg.count))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: _msg.count))
                
                alert.setValue(attributedString, forKey: "attributedMessage")
            }
            
            for i in 0...btnTitles.count - 1 {
                let title = btnTitles[i]
                
                let titleAction = UIAlertAction(title: title, style: .default) { (action) in
                    callback?(i, title)
                }
                titleAction.setValue(UIColor.color0x666666, forKey: "titleTextColor")
                alert.addAction(titleAction)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.themeYellow, forKey: "titleTextColor")
            alert.addAction(cancelAction)
            
            if let vc = XDUtils.currentVC {
                if XDAppConfig.isIPhone {
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                } else {
                    let popPresenter = alert.popoverPresentationController
                    popPresenter?.sourceView = sourceView ?? vc.view
                    popPresenter?.sourceRect = sourceView?.bounds ?? vc.view.bounds
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension XDHUD {
    /// 带输入框的 alert
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - msg: <#msg description#>
    ///   - btnTitles: <#btnTitles description#>
    ///   - sourceView: <#sourceView description#>
    ///   - configurationHandler: <#configurationHandler description#>
    ///   - callback: <#callback description#>
    static func alertWithTextField(title: String? = nil ,msg: String? = nil, placeholder: String?, btnTitles: [String], sourceView: UIView? = nil, configurationHandler: ((UITextField) -> Void)? = nil, callback: ((_ index: Int, _ title: String) -> Void)? = nil) {
        DispatchQueue.main.async {
            XDHUD.closeHUD()
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.font = .systemFont(ofSize: 14)
                textField.textColor = .color0x1A1A1A
                textField.placeholder = placeholder
                textField.borderStyle = .none
                textField.snp.makeConstraints({ $0.height.equalTo(40)} )
                
                if let placeholder = textField.placeholder {
                    textField.attributedPlaceholder = NSAttributedString.init(string: placeholder, attributes: [.foregroundColor: UIColor.textFieldPlaceholder])
                }
                
                configurationHandler?(textField)
            }
            
            if let subView = alert.view.subviews.first,
               let subSubView = subView.subviews.first {
                subSubView.backgroundColor = .white
                subSubView.layer.cornerRadius = 15
            }
            
            if let _title = title {
                let attributedString = NSMutableAttributedString(string: _title)
                attributedString.addAttribute(.foregroundColor, value: UIColor.color0x1A1A1A, range: NSRange(location: 0, length: _title.count))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: _title.count))
                
                alert.setValue(attributedString, forKey: "attributedTitle")
            }
            
            if let _msg = msg {
                let attributedString = NSMutableAttributedString(string: _msg)
                attributedString.addAttribute(.foregroundColor, value: UIColor.color0x300000, range: NSRange(location: 0, length: _msg.count))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: _msg.count))
                
                alert.setValue(attributedString, forKey: "attributedMessage")
            }
            
            for i in 0...btnTitles.count - 1 {
                let title = btnTitles[i]
                
                let titleAction = UIAlertAction(title: title, style: .default) { (action) in
                    callback?(i, title)
                }
                
                if btnTitles.count == 1 {
                    titleAction.setValue(UIColor.themeYellow, forKey: "titleTextColor")
                } else if btnTitles.count == 2 {
                    if i == 0 {
                        titleAction.setValue(UIColor.color0x666666, forKey: "titleTextColor")
                    } else {
                        titleAction.setValue(UIColor.themeYellow, forKey: "titleTextColor")
                    }
                } else {
                    titleAction.setValue(UIColor.color0x666666, forKey: "titleTextColor")
                }
                
                alert.addAction(titleAction)
            }
            
            if let vc = XDUtils.currentVC {
                if XDAppConfig.isIPhone {
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                } else {
                    let popPresenter = alert.popoverPresentationController
                    popPresenter?.sourceView = sourceView ?? vc.view
                    popPresenter?.sourceRect = sourceView?.bounds ?? vc.view.bounds
                    vc.presentIgnoreAbove(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - 常用统一提示
extension XDHUD {
    static func toastUserLoginSuccess() {
        toast("登录成功！")
    }
}
