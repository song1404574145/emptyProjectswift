//
//  XDDataExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

public extension Data {
    /// Data -> Array
    func toArray() -> [Any]? {
        return toArrayOrDictionary() as? [Any]
    }
    
    /// Data -> Dictionary
    func toDictionary() -> [String:Any]? {
        return toArrayOrDictionary() as? [String:Any]
    }
    
    /// Data -> JSON
    private func toArrayOrDictionary() -> Any? {
        do {
            let data = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            return data
        } catch {
            return nil
        }
    }
}
