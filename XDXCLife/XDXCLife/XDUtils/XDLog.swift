//
//  XDLog.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation

public protocol XDLogLevel {
    func yqDescription(level: Int) -> String
}

/// 输出日志
public func XDLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    // 为日期格式器设置格式字符串
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // 使用日期格式器格式化当前日期、时间
    let datestr = dformatter.string(from: Date())
    
    if message is Dictionary<String, Any> {
        print("\(datestr)：[\(fileName):line:\(line)]- \((message as! Dictionary<String, Any>).yqDescription(level: 0))")
    }else if message is Array<Any> {
        print("\(datestr)：[\(fileName):line:\(line)]- \((message as! Array<Any> ).yqDescription(level: 0))")
    }else if message is CustomStringConvertible {
        print("\(datestr)：[\(fileName):line:\(line)]- \((message as! CustomStringConvertible).description)")
    }else {
        print("\(datestr)：[\(fileName):line:\(line)]- \(message)")
    }
    #endif
}


// MARK: - 重写可选型description
extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "Optional(null)"
        case .some(let obj):
            if let obj = obj as? CustomStringConvertible, obj is Dictionary<String, Any> {
                return "Optional:" + "\((obj as! Dictionary<String, Any>).yqDescription(level: 0))"
            }
            if let obj = obj as? CustomStringConvertible, obj is Array<Any> {
                return "Optional:" + "\((obj as! Array<Any>).yqDescription(level: 0))"
            }
            return  "Optional" + "(\(obj))"
        }
    }
}

// MARK: - 重写字典型description
extension Dictionary: XDLogLevel {
    var description: String {
        var str = ""
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, s.unicodeStr))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Dictionary).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: "}")
        return str
    }
    
    public func yqDescription(level: Int) -> String{
        var str = ""
        var tab = ""
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t%@ = \"%@\",\n", tab, key as! CVarArg, s.unicodeStrWith(level: level)))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Dictionary).yqDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Array<Any>).yqDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@}", tab))
        return str
    }
}

extension Array: XDLogLevel {
    var description: String {
        var str = ""
        str.append(contentsOf: "[\n")
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t\"%@\",\n", s.unicodeStr))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Dictionary<String, Any>).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@,\n", "\(value)"))
            }
        }
        str.append(contentsOf: "]")
        return str
    }
    
    public func yqDescription(level: Int) -> String {
        var str = ""
        var tab = ""
        str.append(contentsOf: "[\n")
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t\"%@\",\n", tab, s.unicodeStrWith(level: level)))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Dictionary<String, Any>).yqDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Array<Any>).yqDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@]", tab))
        return str
    }
}

// MARK: - unicode转码
extension String {
    func unicodeStrWith(level: Int) -> String {
        let s = self
        let data = s.data(using: .utf8)
        if let data = data {
            if let id = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                if id is Array<Any> {
                    return (id as! Array<Any>).yqDescription(level: level + 1)
                }else if id is Dictionary<String, Any> {
                    return (id as! Dictionary<String, Any>).yqDescription(level: level + 1)
                }
            }
        }
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    var unicodeStr:String {
        return self.unicodeStrWith(level: 1)
    }
}
