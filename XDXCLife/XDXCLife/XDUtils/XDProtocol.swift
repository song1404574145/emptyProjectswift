//
//  XDProtocol.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

// MARK: - allValues
/// 需要返回所有元素的集合
public protocol YQEnumeratableProtocol {
    static var allValues: [Self] { get }
}

// MARK: - reuseIdentifier
/// 返回标识符
public protocol YQReusable: class {
    static var reuseIdentifier: String { get }
}

extension UIView: YQReusable {
    /// 用当前类名做 reuseIdentifier
    public static var reuseIdentifier: String {
        return "\(self)"
    }
    
    public static func xib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    public static func viewWithXib() -> Self {
        return xib().instantiate(withOwner: nil, options: nil).last as! Self
    }
}

extension UIViewController: YQReusable {
    /// 用当前类名做 reuseIdentifier
    public static var reuseIdentifier: String {
        return "\(self)"
    }
}

// MARK: - 初始化cell
public extension UICollectionView {
    /// 使用 indexPath 重用cell方法，cell必须是注册的
    ///
    ///     let cell: MyTableViewCell = tableView.dequeueReusableCell(indexPath)
    ///     return cell
    ///
    /// - Parameter indexPath: IndexPath
    func dequeueReusableCell<T: YQReusable>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

public extension UITableView {
    /// 使用 indexPath 重用cell方法，cell必须是注册的
    ///
    ///     let cell: MyTableViewCell = tableView.dequeueReusableCell(indexPath)
    ///     return cell
    ///
    /// - Parameter indexPath: IndexPath
    func dequeueReusableCell<T: YQReusable>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    /// 得到一个不一定注册过的 cell
    ///
    ///     let cell: MyTableViewCell = tableView.dequeueReusableCell(indexPath)
    ///     return cell!
    ///
    /// - Parameter indexPath: IndexPath
    func dequeueReusableCell<T: YQReusable>() -> T? {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
    }
}
