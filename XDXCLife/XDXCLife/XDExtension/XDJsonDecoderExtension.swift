import UIKit
import Foundation

public extension Decodable {
    /// JSON to Model
    /// - Parameter dic: [String:Any]
    static func jsonToModel(_ dic: [String:Any]) -> Self? {
        do {
            if let data = dic.toData() {
                // 解码
                return try JSONDecoder().decode(Self.self, from: data)
            }
            
            return nil
        } catch let error {
            XDLog(error.localizedDescription)
            return nil
        }
    }
    
    /// Array to ArrayModel
    /// - Parameter arr: [[String: Any]]
    static func arrayToModels(_ arr: [[String: Any]]) -> [Self] {
        do {
            if let data = arr.toData() {
                return try JSONDecoder().decode([Self].self, from: data)
            }
            
            return []
        } catch let error {
            XDLog(error.localizedDescription)
            return []
        }
    }
}

public extension Encodable {
    /// Model to String
    func modelToString() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            
            return ""
        } catch {
            return ""
        }
    }
}

// https://kemchenj.github.io/2018-07-09/
// 或许你并不需要重写 init(from:) 方法
public extension KeyedDecodingContainer {
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if let bool = try? decode(type, forKey: key) {
            return bool
        } else if let int = try? decode(Int.self, forKey: key) {
            return Bool(exactly: int as NSNumber)
        } else {
            return nil
        }
    }
    
    func decodeIfPresent(_ type: URL.Type, forKey key: K) throws -> URL? {
        guard let str = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        
        return URL(string: str)
    }
}
