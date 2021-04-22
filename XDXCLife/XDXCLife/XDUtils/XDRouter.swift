//
//  XDRouter.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation
import SKPhotoBrowser

typealias XDBaseRouterCompletion = () -> Void
/// 页面反向传值
typealias XDBaseRouterPageCallBack = (Any?) -> Void

protocol XDBaseRouterPageProtocol {
    var vc: UIViewController? { get }
}

enum XDRouterPage: XDBaseRouterPageProtocol {
//MARK: - 登录模块
    /// 登录
    case login
    /// 注册
//    case register
    
// MARK: - 首页模块
    /// 首页
    case homeVC
    
// MARK: - 分类模块
    /// 分类
    case classifyVC
    
// MARK: - 线下模块
    /// 线下
    case offlineStores
    
// MARK: - 购物车模块
    /// 购物车
    case shoppingTrolley
    
// MARK: - 我的模块
    /// 我的
    case mine
    
    var vc: UIViewController? {
        switch self {
        case .login: return XDLoginVC()
//        case .register: return UIViewController()
        case .homeVC: return XDHomeVC()
        case .classifyVC: return XDClassifyVC()
        case .offlineStores: return XDOfflineStoresVC()
        case .shoppingTrolley: return XDShoppingTrolleyVC()
        case .mine: return XDMineVC()
        }
    }
    
    var pageScheme: String? {
        switch self {
        default:
            return nil
        }
    }
}

protocol XDBaseRouterProtocol {
    func go(with navigation: UINavigationController?, animated: Bool, completion: XDBaseRouterCompletion?)
}

enum XDRouter: XDBaseRouterProtocol {
    case push(XDRouterPage, parameter: Any?, callBack: XDBaseRouterPageCallBack?)
    case present(XDRouterPage, parameter: Any?, callBack: XDBaseRouterPageCallBack?)
    
    func go(with navigation: UINavigationController?, animated: Bool, completion: XDBaseRouterCompletion? = nil) {
        let nav = navigation ?? XDUtils.currentNav
        
        switch self {
        case .push(let page, let parameter, let callBack):
            guard let vc = page.vc else {
                XDLog("push失败，vc 不存在")
                return
            }
            if let baseVC = vc as? XDBaseVC {
                baseVC.config(data: parameter, callBack: callBack)
            }
            
            (nav ?? nav?.navigationController ?? nav?.topViewController?.navigationController)?.pushViewController(vc)
        case .present(let page, let parameter, let callBack):
            guard let vc = page.vc else {
                XDLog("push失败，vc 不存在")
                return
            }
            var presentVC = vc
            
            if let baseVC = vc as? XDBaseVC {
                baseVC.config(data: parameter, callBack: callBack)
                presentVC = XDBaseNav(rootViewController: baseVC)
            } else if let nav = presentVC as? XDBaseNav, let baseVC = nav.topViewController as? XDBaseVC {
                baseVC.config(data: parameter, callBack: callBack)
            }
            
            (nav ?? nav?.navigationController ?? nav?.topViewController?.navigationController)?.presentIgnoreAbove(presentVC, animated: animated, completion: completion)
        }
    }
}
