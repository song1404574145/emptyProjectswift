//
//  XDBaseNav.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit

class XDBaseNav: UINavigationController, UIGestureRecognizerDelegate {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}

extension XDBaseNav {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        }
        
        return true
    }
}
