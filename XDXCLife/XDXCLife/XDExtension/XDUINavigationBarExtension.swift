//
//  XDUINavigationBarExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import Foundation

extension UINavigationBar {
    //解决导航栏滑动返回时出现三个小白点的BUG:
    override open func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        guard let className = NSClassFromString("UINavigationItemButtonView") else {
            return
        }
        
        if view.isKind(of: className) {
            view.isHidden = true
        }
    }
}
