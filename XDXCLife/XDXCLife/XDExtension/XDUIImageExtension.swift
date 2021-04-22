//
//  XDUIImageExtension.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit
import Foundation

public extension UIImage {
    convenience init?(name: String, isCache: Bool) {
        if isCache == false {
            if let path = Bundle.main.path(forResource: name, ofType: "png") {
                self.init(contentsOfFile: path)
            }else if let path = Bundle.main.path(forResource: name + "@2x", ofType: "png") {
                self.init(contentsOfFile: path)
            }else if let path = Bundle.main.path(forResource: name + "@3x", ofType: "png") {
                self.init(contentsOfFile: path)
            }else if let path = Bundle.main.path(forResource: name, ofType: "jpg") {
                self.init(contentsOfFile: path)
            }else {
                self.init(named: name)
            }
        } else {
            self.init(named: name)
        }
    }
}

// MARK: - 转换
public extension UIImage {
    /// 图片压缩
    /// - Parameter maxLength: 限制文件 最大 kb
    func imgCompress(maxLength: Int) -> Data? {
        var compress:CGFloat = 0.5
        var data = self.jpegData(compressionQuality: compress)
        
        guard data != nil else {
            return nil
        }
        
        while (data!.count) > maxLength && compress > 0.01 {
            compress -= 0.02
            data = self.jpegData(compressionQuality: compress)
        }
        
        return data
    }
    
    func toScaleToSize(newSize: CGSize)-> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return  scaledImage
    }
    
    func toScaleToRadius(radius: CGFloat, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        //绘制路线
        let content = UIGraphicsGetCurrentContext()
        content?.addPath(UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: UIRectCorner.allCorners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        //裁剪
        content?.clip()
        //将原图片画到图形上下文
        self.draw(in: rect)
        content?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        return output
    }
    
    var toJPEGData: Data! {
        return self.jpegData(compressionQuality: 1.0)     // QUALITY min = 0 / max = 1
    }
    
    var toPNGData: Data! {
        return self.pngData()
    }
}

// MARK: - 富文本
public extension UIImage {
    func toAttributedString(imageSize: CGSize, y: CGFloat) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = self
        attachment.bounds = CGRect(x: 0, y: -y, width: imageSize.width , height: imageSize.height)
        
        let textAttachmentString = NSAttributedString(attachment: attachment)
        return textAttachmentString
    }
}

public extension UIImageView {
    /// 获取本地图像
    func retrivevName(name: String) {
        self.image = UIImage(name: name, isCache: false)
    }
}

// MARK: - 生成圆形图片
public extension UIImage {
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2, y: (shotest-self.size.height)/2, width: self.size.width, height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
}
