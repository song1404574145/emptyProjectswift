//
//  XDBaseTabBar.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit
import ESTabBarController_swift

class XDBaseTabBar: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbar()
        addObservers()
    }
}

extension XDBaseTabBar {
    private func addObservers() {
        XDNotifiCenter.addObserver(self, selector: #selector(notifiReceive(_:)), name: .userDidLogin, object: nil)
    }
    
    @objc private func notifiReceive(_ sender: Notification) {
        
    }
}

extension XDBaseTabBar {
    private func setupTabbar() {
        // 设置tabbar 样式
        tabBarController?.view.backgroundColor = .tabBarBackground
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundEffect = nil
            
            if kStatusbarHeight == 20 {
                appearance.shadowImage = UIColor.tabBarShadow.toImage()
                appearance.backgroundImage = UIColor.navBarBackground.toImage()
            } else {
                appearance.shadowImage = UIColor.tabBarShadow.toImage()
                appearance.backgroundImage = UIColor.navBarBackground.toImage()
            }
            
            tabBar.standardAppearance = appearance
            tabBar.reloadInputViews()
        } else {
            // Fallback on earlier versions
            if kStatusbarHeight == 20 {
                tabBar.shadowImage = UIColor.tabBarShadow.toImage()
                tabBar.backgroundImage = UIColor.navBarBackground.toImage()
            } else {
                tabBar.shadowImage = UIColor.tabBarShadow.toImage()
                tabBar.backgroundImage = UIColor.navBarBackground.toImage()
            }
        }
        
        // 是否拦截操作
        shouldHijackHandler = { _, vc, _ in
            return false
        }
        
        // 拦截操作执行操作
        didHijackHandler = { _, vc, _ in
            
        }
        
        let vc1 = XDRouterPage.homeVC.vc as? XDHomeVC
        vc1?.tabBarItem = ESTabBarItem(ExampleBasicContentView(), title: "首页", image: UIImage(named: "ic_test"), selectedImage: UIImage(named: "ic_test_select"))
        
        let vc2 = XDRouterPage.classifyVC.vc as? XDClassifyVC
        vc2?.tabBarItem = ESTabBarItem(ExampleBasicContentView(), title: "分类", image: UIImage(named: "ic_test"), selectedImage: UIImage(named: "ic_test_select"))
        
        let vc3 = XDRouterPage.offlineStores.vc as? XDOfflineStoresVC
        vc3?.tabBarItem = ESTabBarItem(ExampleBasicContentView(), title: "线下", image: UIImage(named: "ic_test"), selectedImage: UIImage(named: "ic_test_select"))
        
        let vc4 = XDRouterPage.shoppingTrolley.vc as? XDShoppingTrolleyVC
        vc4?.tabBarItem = ESTabBarItem(ExampleBasicContentView(), title: "购物车", image: UIImage(named: "ic_test"), selectedImage: UIImage(named: "ic_test_select"))
        
        let vc5 = XDRouterPage.mine.vc as? XDMineVC
        vc5?.tabBarItem = ESTabBarItem(ExampleBasicContentView(), title: "我的", image: UIImage(named: "ic_test"), selectedImage: UIImage(named: "ic_test_select"))
        
        viewControllers = [XDBaseNav(rootViewController: vc1!),
                           XDBaseNav(rootViewController: vc2!),
                           XDBaseNav(rootViewController: vc3!),
                           XDBaseNav(rootViewController: vc4!),
                           XDBaseNav(rootViewController: vc5!)]
    }
}

/// tabbar Item
class ExampleBasicContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.tabBar
        highlightTextColor = UIColor.tabBarSelected
        
        renderingMode = .alwaysOriginal
        imageView.contentMode = .scaleAspectFit
    }
    
    override func updateLayout() {
        titleLabel.font = .tabBar
        titleLabel.sizeToFit()
        
        super.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
