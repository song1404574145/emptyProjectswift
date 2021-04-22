//
//  XDArrayExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

public extension Array where Element: Equatable {
    /// 删除元素
    /// - Parameter object: 数组中的元素，不存在不会删除
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

public extension Array {
    /// Array -> Data
    /// - Parameter options: JSONSerialization.WritingOptions
    func toData(options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            return data
        } catch _ {
            return nil
        }
    }
}
