import Foundation
import UIKit

extension UIImageView {
    /// 切换颜色
    public func switchColor(_ color: UIColor) {
        tintColor = color
        image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    /// 切换颜色
    public func switchColor(_ rgbValue: Int) {
        switchColor(UIColor(hex: rgbValue) ?? .clear)
    }
}

// MARK: - Kingfisher 加载网络图片
import Kingfisher
public extension UIImageView {
    // ---------- String ----------
    func setAvatarImage(with string: String?, radius: CGFloat, corners: RectCorner = .all, size: CGSize) {
        setAvatarImage(with: string?.url, radius: radius, corners: corners, size: size)
    }
    
    func setAvatarImage(with string: String?, radius: CGFloat, corners: RectCorner = .all) {
        setAvatarImage(with: string?.url, radius: radius, corners: corners)
    }
    
    func setAvatarImage(_ string: String?) {
        setImage(string?.url, placeholder: UIImage.avatarDefault)
    }
    
    func setImage(_ string: String?, placeholder: UIImage? = nil) {
        setImage(string?.url, placeholder: placeholder)
    }
    
    func setImage(with string: String?, radius: CGFloat, corners: RectCorner = .all, size: CGSize) {
        setImage(with: string?.url, radius: radius, corners: corners, size: size)
    }
    
    func setImage(with string: String?, radius: CGFloat, corners: RectCorner = .all, size: CGSize, placeholder: UIImage?) {
        setImage(with: string?.url, radius: radius, corners: corners, size: size, placeholder: placeholder)
    }
    
    // ---------- URL ----------
    func setAvatarImage(with url: URL?, radius: CGFloat, corners: RectCorner = .all, size: CGSize) {
        setImage(with: url, radius: radius, corners: corners, size: size, placeholder: UIImage.avatarDefault)
    }
    
    func setAvatarImage(with url: URL?, radius: CGFloat, corners: RectCorner = .all) {
        setAvatarImage(with: url, radius: radius, corners: corners, size: CGSize(width: radius, height: radius))
    }
    
    func setImage(_ url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
    
    func setImage(with url: URL?, radius: CGFloat, corners: RectCorner = .all, size: CGSize) {
        setImage(with: url, radius: radius, corners: corners, size: size, placeholder: nil)
    }
    
    func setImage(with url: URL?, radius: CGFloat, corners: RectCorner = .all, size: CGSize, placeholder: UIImage?) {
        self.contentMode = .scaleToFill
        
        let radius = radius * UIScreen.main.scale * 2
        let size = CGSize(width: size.width * UIScreen.main.scale * 2, height: size.height * UIScreen.main.scale * 2)
        
        let processor = (ResizingImageProcessor(referenceSize: size, mode: .aspectFill) |> CroppingImageProcessor(size: size)) |> RoundCornerImageProcessor(cornerRadius: radius, targetSize: size, roundingCorners: corners, backgroundColor: nil)
        
        if layer.animationKeys() == nil {
            self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.3)), .processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        } else {
            self.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        }
    }
}

// MARK: - GIF
public extension UIImageView {
    func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

public extension UIImage {
    convenience init?(gifName: String) {
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif"), let imageData = try? Data(contentsOf: url) {
            self.init(data: imageData)
        } else {
            self.init(named: gifName)
        }
    }
}

public extension UIImage {
    class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}
