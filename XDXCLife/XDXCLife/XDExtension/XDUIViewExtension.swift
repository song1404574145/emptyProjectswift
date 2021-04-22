import UIKit

public extension UIView {
    /// 移除渐变背景
    func removeGradientBGLayer() {
        layer.sublayers?.filter({ $0 is YQCAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
    }
    
    /// 添加渐变背景  endPoint 左右渐变：0,0 -> 1,0、上下渐变：0,0 -> 0,1
    func addGradientBGLayer(frame: CGRect? = nil,
                            colors: [CGColor] = [UIColor(red: 0.38, green: 0, blue: 0.41, alpha: 1).cgColor, UIColor(red: 0.96, green: 0.36, blue: 0.36, alpha: 1).cgColor],
                            locations: [NSNumber] = [0, 1],
                            startPoint: CGPoint = CGPoint(x: 0, y: 0),
                            endPoint: CGPoint = CGPoint(x: 1, y: 0)) {
        
        removeGradientBGLayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let gradient = YQCAGradientLayer()
            gradient.frame = frame ?? self.bounds
            gradient.colors = colors
            gradient.locations = locations
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
            self.layer.insertSublayer(gradient, at: 0)
        }
    }
}

class YQCAGradientLayer: CAGradientLayer {
    
}

public extension UIView {
    func autoHeight() {
        setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
    }
    
    func autoWidth() {
        setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
    }
}

public extension UIView {
    /// 设置部分圆角，需要设置背景色为 nil
    /// - Parameters:
    ///   - corners: 圆角位置
    ///   - radii: 圆角大小
    func addRoundedCorners(_ corners: UIRectCorner, radii: CGFloat, size: CGSize? = nil, color: UIColor? = nil) {
        removeRoundedCorners()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.backgroundColor = nil
            
            let frame = CGRect(origin: CGPoint.zero, size: size ?? self.bounds.size)
            let path = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
            let shapeLayer = YQCAShapeLayer()
            shapeLayer.frame = frame
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = (color ?? .white).cgColor
            shapeLayer.masksToBounds = true
            
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
    }
    
    /// 重置部分圆角
    func removeRoundedCorners() {
        layer.sublayers?.filter({ $0 is YQCAShapeLayer }).forEach({ $0.removeFromSuperlayer() })
    }
}

class YQCAShapeLayer: CAShapeLayer {
    
}
