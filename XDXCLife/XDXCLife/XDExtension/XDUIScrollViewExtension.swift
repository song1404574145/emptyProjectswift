//
//  XDUIScrollViewExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit

extension UIScrollView {
    var index: Int {
        return Int(contentOffset.x / kScreenWidth + 0.5)
    }
}
