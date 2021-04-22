//
//  XDBaseVC.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import BFEmptyDataSet

class XDBaseVC: UIViewController {

    override var wx_backImage: UIImage? {
        return UIImage(named: "")
    }
    
    override var wx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [.font: UIFont.navBarTitle, .foregroundColor: UIColor.navBarTitle]
    }
    
    override var wx_barBarTintColor: UIColor? {
        return .navBarBackground
    }
    
    /// 导航栏按钮颜色
    var navBarTintColor: UIColor? {
        didSet {
            wx_navigationBar.tintColor = navBarTintColor
            navigationController?.navigationBar.tintColor = navBarTintColor
        }
    }
    
    /// navBarTintColor
    override var wx_barTintColor: UIColor? {
//        if self is liveVC {
//            return .navBarBackground
//        }
        return navBarTintColor ?? .navBarItem
    }
    override var wx_shadowImageTintColor: UIColor? {
        //        if self is liveVC {
        //            return .navBarBackground
        //        }
        return .navBarShadow
    }
    
    /// 自定义按钮返回事件
    override func wx_backButtonClicked() {
        onBack()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    /// 状态栏
    var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    /// 导航栏标题
    var navbarTitle: String? {
        didSet {
            navigationItem.title = navbarTitle
        }
    }
    var backgroundColor: UIColor {
        return .color0xF5F5F5
    }
    
    /// 空数据状态页面，默认：无数据
    var emptyDataType: XDEmptyDataView.EmptyDataType! {
        didSet {
            showEmptyDataType()
        }
    }
    /// 被添加子vc（addChild），手动赋值
    weak var parentVC: XDBaseVC?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let _ = self.navigationController {
            // 在后台
        } else {
            if self.parent == nil && parentVC == nil {
                //已关闭
                // 触发 deinit
                self.view = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        addObserver(with: .userDidLogout)
        
        setupEmptyDataType()
    }
    
    deinit {
        XDLog("\(self.classForCoder) deinit")
    }
    
    // MARK: - 网络请求
    
    /// 网络加载数据错误处理
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - code: <#code description#>
    ///   - errorMsg: <#errorMsg description#>
    func loadDataFail(_ target: TargetType, _ code: XDHttp.LoadDataResponseCode, _ errorMsg: String?) {
        if let emptyDataTyp = code.emptyDataType {
            self.emptyDataType = emptyDataTyp
        } else {
            emptyDataType = .requestFail(errorTip: errorMsg ?? "服务器出错了，请稍后再试")
        }
    }
    
    /// 网络加载成功处理
    /// - Parameters:
    ///   - page: <#page description#>
    ///   - loadCount: <#loadCount description#>
    ///   - maxLoadCount: <#maxLoadCount description#>
    ///   - isNoMoreData: <#isNoMoreData description#>
    func loadDataSuccess(page: Int = 1, loadCount: Int = 0, maxLoadCount: Int = 0, isNoMoreData: Bool? = nil) {
        removeEmptyDataType()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        XDUtils.dismissKeyboard()
    }
}

// MARK: - 页面传值、通知、按钮等事件
extension XDBaseVC {
    
    /// 页面传值
    /// - Parameters:
    ///   - data: 参数（需要传的值）
    ///   - callBack: 回调
    @objc dynamic func config(data: Any?, callBack: XDBaseRouterPageCallBack?) {
        
    }
    
    /// 添加观察者，需要重写notifiReceive
    /// - Parameters:
    ///   - name: 通知名字
    ///   - observer: 可选，默认：self
    ///   - selecter: 可选，默认：notifiReceive
    ///   - object: 可选，默认：nil
    func addObserver(with name: NSNotification.Name, observer: Any? = nil, selecter: Selector? = nil, object: Any? = nil) {
        XDNotifiCenter.addObserver(observer ?? self, selector: selecter ?? #selector(notifiReceive(_:)), name: name, object: object)
    }
    
    /// 通知响应事件
    /// - Parameter sender: Notification
    @objc dynamic func notifiReceive(_ sender: Notification) {
        
    }
    
    /// 点击返回按钮事件
    @objc dynamic func onBack() {
        XDUtils.dismissKeyboard()
        XDHUD.closeHUD()
        
        if presentationController != nil {
            if let navc = navigationController, navc.viewControllers.count > 1 {
                navigationController?.popViewController(animated: true)
            } else {
                dismissIgnoreAbove(animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - navbarItem
extension XDBaseVC {
    /// 导航栏添加左边按钮
    /// - Parameters:
    ///   - view: 自定义视图
    ///   - target: 响应事件对象
    ///   - action: 响应事件
    /// - Returns: 按钮
    @discardableResult
    func addLeftNabbarItem(custom view: UIView) -> UIBarButtonItem? {
        var barButtonItems = navigationItem.leftBarButtonItems ?? []
        
        if view.frame == .zero {
            view.frame = CGRect(x: 0, y: 0, width: 41, height: 44)
        }
        
        let btn = UIBarButtonItem(customView: view)
        btn.tintColor = view.tintColor ?? .navBarItem
        barButtonItems.append(btn)
        
        navigationItem.leftBarButtonItems = barButtonItems
        return btn
    }
    
    /// 导航栏添加左边按钮
    /// - Parameters:
    ///   - imageName: 图片名字
    ///   - target: 响应事件对象
    ///   - action: 响应事件
    /// - Returns: 按钮
    @discardableResult
    func addLeftNabbarItem(imageName: String, target: Any?, action: Selector) -> UIBarButtonItem? {
        var barButtonItems = navigationItem.leftBarButtonItems ?? []
        
        let btn = UIBarButtonItem(image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), style: .plain, target: target, action: action)
        barButtonItems.append(btn)
        
        navigationItem.leftBarButtonItems = barButtonItems
        return btn
    }
    
    /// 导航栏添加右边按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - target: 响应事件对象
    ///   - action: 响应事件
    /// - Returns: 按钮
    @discardableResult
    func addRightNabbarItem(title: String, target: Any?, action: Selector) -> UIBarButtonItem? {
        var barButtonItems = navigationItem.rightBarButtonItems ?? []
        
        let btn = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        btn.tintColor = .navBarItem
        
        var attributes: [NSAttributedString.Key : Any] = [.font: UIFont.navBarItem, .foregroundColor: UIColor.navBarItem]
        btn.setTitleTextAttributes(attributes, for: .normal)
        btn.setTitleTextAttributes(attributes, for: .selected)
        btn.setTitleTextAttributes(attributes, for: .highlighted)
        
        attributes[.foregroundColor] = UIColor.navBarItemDisable
        btn.setTitleTextAttributes(attributes, for: .disabled)
        
        barButtonItems.append(btn)
        
        navigationItem.rightBarButtonItems = barButtonItems
        return btn
    }
    
    /// 导航栏添加右边按钮
    /// - Parameters:
    ///   - view: 自定义视图
    ///   - target: 响应事件对象
    ///   - action: 响应事件
    /// - Returns: 按钮
    @discardableResult
    func addRightNabbarItem(custom view: UIView) -> UIBarButtonItem? {
        var barButtonItems = navigationItem.rightBarButtonItems ?? []
        
        if view.frame == .zero {
            view.frame = CGRect(x: 0, y: 0, width: 41, height: 44)
        }
        
        let btn = UIBarButtonItem(customView: view)
        btn.tintColor = view.tintColor ?? .navBarItem
        barButtonItems.append(btn)
        
        navigationItem.rightBarButtonItems = barButtonItems
        return btn
    }
    
    /// 导航栏添加右边按钮
    /// - Parameters:
    ///   - imageName: 图片名字
    ///   - target: 响应事件对象
    ///   - action: 响应事件
    /// - Returns: 按钮
    @discardableResult
    func addRightNabbarItem(imageName: String, target: Any?, action: Selector) -> UIBarButtonItem? {
        var barButtonItems = navigationItem.rightBarButtonItems ?? []
        
        let btn = UIBarButtonItem(image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), style: .plain, target: target, action: action)
        barButtonItems.append(btn)
        
        navigationItem.rightBarButtonItems = barButtonItems
        return btn
    }
}

// MARK: - 空数据页面设置
extension XDBaseVC: BFEmptyDataSetDelegate, BFEmptyDataSetSource {
    /// 初始化 emptyDataSet，设置 BFEmptyDataSetDelegate，BFEmptyDataSetSource
    @objc dynamic func setupEmptyDataType() {
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
    }
    /// 展示错误页面，根据 emptyDataType 来显示不同的状态
    @objc dynamic func showEmptyDataType() {
        view.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.removeEmptyDataSet()
            self.view.reloadEmptyDataSet()
        }
    }
    /// 移除错误页面
    @objc dynamic func removeEmptyDataType() {
        view.removeEmptyDataSet()
    }
    
    /// 错误页面事件
    /// - Parameter type: 错误类型
    @objc dynamic func tapEmptyDataType() {
        XDUtils.dismissKeyboard()
        
        if emptyDataType == .noLogin {
            
        } else if emptyDataType == .noLocationAuth {
            XDUtils.openSetting()
        }
    }
    
    @objc dynamic func emptyDataSetViewFrame() -> CGRect {
        return view.bounds
    }
    
    final func emptyDataSetDidTap(_ view: UIView!) {
        tapEmptyDataType()
    }
    
    final func customView(_ view: UIView) {
        
        
        
    }
    
    
}
