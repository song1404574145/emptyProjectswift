//
//  XDStringExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import Foundation

public extension String {
    /// 验证手机号
    var checkPhone: Bool {
        return self.count == 11
    }
    /// 验证验证码
    var checkSMSCode: Bool {
        return self.count > 3
    }
    /// 验证密码
    var checkPassword: Bool {
        return self.count >= 6
    }
    var isURL: Bool {
        return self.contains("http") || self.contains("https")
    }
}

public extension String {
    /// OC doubleValue
    var doubleValue: Double { return NSString(string: self).doubleValue }
    /// Double?
    var double: Double? { return Double(self) }
    /// Float?
    var float: Float?   { return Float(self) }
    /// Int?
    var int: Int?       { return Int(self) }
    /// OC length
    var length: Int     { return NSString(string: self).length }
    /// Data?
    var data: Data?     { return data(using: String.Encoding.utf8) }
    /// [Any]?
    var array: [Any]?  { return data?.toArray() }
    /// [String: Any]?
    var dictionary: [String: Any]? { return data?.toDictionary() }
}

public extension String {
    /// 字符串替换
    /// - Parameters:
    /// - range: 替换范围
    /// - string: 替换⽂本
    mutating func replace(range: Range<Int>, with string:
                            String) {
        if range.lowerBound >= 0 && range.upperBound <=
            self.count {
            let startIndex = self.index(self.startIndex, offsetBy:
                                            range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy:
                                        range.upperBound)
            self.replaceSubrange(startIndex..<endIndex, with:
                                    string)
        }
    }
    /// 字符串去除前后空格
    var trim: String {
        let set: CharacterSet =
            CharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: set)
    }
    /// 字符串去除所有空格
    var trimAll: String {
        return trim.delete(" ")
    }
    /// 字符串切割
    /// - Parameter index: <#index description#>
    /// - Returns: <#return value description#>
    func substring(to index: Int) -> String {
        if self.count >= index {
            let endIndex = self.index(self.startIndex, offsetBy:
                                        index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    /// 字符串切割
    /// - Parameter index: <#index description#>
    /// - Returns: <#return value description#>
    func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy:
                                            index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    /// 字符串切割
    /// - Parameter range: <#range description#>
    /// - Returns: <#return value description#>
    func substring(with range: Range<Int>) -> String {
        if range.lowerBound >= 0 && range.upperBound <=
            self.count {
            let startIndex = self.index(self.startIndex, offsetBy:
                                            range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy:
                                        range.upperBound)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    /// 字符串删除
    /// - Parameter character: 要删除的字符串
    /// - Returns: newString
    func delete(_ character: String) -> String {
        return replacingOccurrences(of: character, with: "")
    }
    /// 字符串 height
    /// - Parameters:
    /// - font: 字体
    /// - width: 字符串显示的宽度
    /// - lineSpace: ⾏间距
    /// - isCheckOneLineText: 处理单⾏⽂本⾼度？(单⾏⽂本设置了⾏间距，有中⽂会多⼀个⾏间距的⾼度，需要处理掉)
    /// - Returns: 字符串⾼度
    func textHeight(_ font: UIFont, width: CGFloat,
                    lineSpace: CGFloat = 0, isCheckOneLineText: Bool =
                        true) -> CGFloat {
        return textSize(CGSize(width: width, height:
                                CGFloat.greatestFiniteMagnitude), font: font, lineSpace:
                                    lineSpace, isCheckOneLineText:
                                        isCheckOneLineText).height
    }
    /// 字符串 width
    /// - Parameters:
    /// - font: 字体
    /// - height: 字符串显示的⾼度
    /// - lineSpace: ⾏间距
    /// - isCheckOneLineText: 处理单⾏⽂本⾼度？(单⾏⽂本设置了⾏间距，有中⽂会多⼀个⾏间距的⾼度，需要处理掉)
    /// - Returns: 字符串宽度
    func textWidth(_ font: UIFont, height: CGFloat,
                   lineSpace: CGFloat = 0, isCheckOneLineText: Bool =
                    true) -> CGFloat {
        return textSize(CGSize(width:
                                CGFloat.greatestFiniteMagnitude, height: height), font:
                                    font, lineSpace: lineSpace, isCheckOneLineText:
                                        isCheckOneLineText).width
    }
    /// 字符串 size
    /// - Parameters:
    /// - size: 显示 size
    /// - font: 字体
    /// - lineSpace: ⾏间距
    /// - isCheckOneLineText: 处理单⾏⽂本⾼度？(单⾏⽂本设置了⾏间距，有中⽂会多⼀个⾏间距的⾼度，需要处理掉)
    /// - Returns: 字符串 size
    func textSize(_ size: CGSize, font: UIFont, lineSpace:
                    CGFloat = 0, isCheckOneLineText: Bool = true) ->
    CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let attributeString =
            NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: font, range: NSRange(location: 0, length:
                                                                    attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:
                                        NSRange(location: 0, length: attributeString.length))
        var rect = attributeString.boundingRect(with: size,
                                                options:
                                                    [NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     NSStringDrawingOptions.usesFontLeading], context: nil)
        if isCheckOneLineText && rect.size.height -
            font.lineHeight <= paragraphStyle.lineSpacing {
            if isContainChinese {
                rect = CGRect(x: rect.origin.x, y: rect.origin.y,
                              width: rect.size.width, height: rect.size.height -
                                paragraphStyle.lineSpacing)
            }
        }
        return rect.size
    }
}

public extension String {
    /// 判断是否包含中文字符
    var isContainChinese: Bool {
        let nsstring = self as NSString
        for index in 0..<nsstring.length {
            let s = nsstring.character(at: index)
            
            if s > 0x4e00 && s < 0x9fff {
                return true
            }
        }
        return false
    }
}

public extension String {
    /// 转计时
    var timer: String {
        let time = int ?? 0
        
        let h = time / 3600
        let m = (time - (h * 3600)) / 60
        let s = time - (h * 3600) - (m * 60)
        
        var timeStr = ""
        if h > 0 {
            timeStr += "\(h):"
        }
        timeStr += (m >= 10 ? "\(m):" : "0\(m):")
        timeStr += (s >= 10 ? "\(s)" : "0\(s)")
        
        return timeStr
    }
    
    /// 转换money(保留两位小数)
    var money: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let double = double, let str = formatter.string(from: NSNumber(value: double)) {
            return str
        }
        
        return ""
    }
    
    /// 转换TimeInterval
    var timeInterval: TimeInterval {
        var timeStr = ""
        
        if self.count > 10 {
            timeStr = self.yq_subString(to: 10)
        } else {
            timeStr = self
        }
        
        if let time = TimeInterval(timeStr) {
            return time
        } else {
            return 0
        }
    }
    
    /// 转MD5
    var md5: String {
        if let data = self.data(using: .utf8, allowLossyConversion: true) {
            #if swift(>=5.0)
            let message = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                return [UInt8](bytes)
            }
            #else
            let message = data.withUnsafeBytes { bytes in
                return [UInt8](UnsafeBufferPointer(start: bytes, count: data.count))
            }
            #endif
            
            let MD5Calculator = MD5(message)
            let MD5Data = MD5Calculator.calculate()
            
            var MD5String = String()
            for c in MD5Data {
                MD5String += String(format: "%02x", c)
            }
            return MD5String
        }
        
        return ""
    }
    
    /// 转urlString
    var urlString: String {
        if !isEmpty, let urlString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if urlString.hasPrefix("http") {
                return urlString
            } else {
//                return YQHttp.fileRootURL + urlString
            }
        }
        
        return ""
    }
    /// 转url
    var url: URL? {
        if !urlString.isEmpty {
            return URL(string: urlString)
        }
        return nil
    }
    
    /// 国际化
    var i18n: String {
        return localized()
    }
}

// MARK: - 裁剪
extension String {
    func yq_subString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func yq_subString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}

// MARK: - 普通文本计算高度
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let boundingBox = sizeWithConstrainedWidth(with: width, font: font)
        return boundingBox.height
    }
    
    func sizeWithConstrainedWidth(with width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
}


// MARK: - 转化
extension String {
    func deleteLeftRightSpace() -> String {
        let text =  trimmingCharacters(in: .whitespaces)
        return text
    }
    
    func toClass() -> AnyClass? {
        if let clsName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String,
           let cls = NSClassFromString(clsName + "." + self) {
            return cls
        }
        return nil
    }
}

extension String {
    func hasPrefix(_ prefixs: [String]) -> Bool {
        for prefix in prefixs {
            
            if hasPrefix(prefix) {
                return true
            }
        }
        
        return false
    }
}

extension String {
    var isImageURL: Bool {
        return contains(".png") || contains(".jpg") || contains(".jpeg") || contains(".gif")
    }
}
