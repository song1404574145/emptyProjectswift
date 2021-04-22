//
//  XDDictionaryExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

public extension Dictionary {
    /// Dictionary -> String
    func toString() -> String? {
        if let data = toData() {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    /// Dictionary -> Data
    func toData() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            return data
        } catch _ {
            return nil
        }
    }
    
    /// 字典生成字符串 & 拼接
    /// - Parameter sort: 字典排序，默认 $0.key > $1.key
    func toParamsString(sort: ((_ key1: String, _ key2: String) -> Bool)? = nil) -> String {
        if let dic = self as? [String: Any] {
            var  key_value_array: [String] = []
            
            for (key, value) in dic.sorted(by: { sort?($0.key, $1.key) ?? ($0.key > $1.key) }) {
                key_value_array.append("\(key)=\(value)")
            }
            
            return key_value_array.joined(separator: "&")
        } else {
            return ""
        }
    }
}
