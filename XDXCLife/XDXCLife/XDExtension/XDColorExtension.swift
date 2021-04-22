//
//  XDColorExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import Foundation

public extension UIColor {
    convenience init(rgbValue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0xFF00) >> 8)/255.0, blue: CGFloat((rgbValue & 0xFF))/255.0, alpha: a)
    }
    
    convenience init(rgbValue: String, a: CGFloat = 1.0) {
        var temHex = rgbValue.uppercased()
        
        if temHex.hasPrefix("0x") || temHex.hasPrefix("##") || temHex.hasPrefix("0X") {
            temHex = (temHex as NSString).substring(from: 2)
        }
        
        if temHex.hasPrefix("#") {
            temHex = (temHex as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (temHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (temHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (temHex as NSString).substring(with: range)
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(self.cgColor)
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
