//
//  XDFunc.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import Foundation

// MARK: - 比大小
func MIN<T : Comparable>(_ a: T, _ b: T) -> T {
    if a < b {
        return a
    }
    return b
}

func MAX<T : Comparable>(_ a: T, _ b: T) -> T {
    if a > b {
        return a
    }
    return b
}

// MARK: - String
/// String拼接
public func + <T>(left: T, right: String) -> String {
    return "\(left)" + right
}
/// String拼接
public func + <T>(left: String, right: T) -> String {
    return left + "\(right)"
}

// MARK: - storyboard
public func storyboard(with name: String) -> ((String) -> UIViewController?) {
    return { (identifier: String) -> UIViewController? in
        UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
