//
//  XDDefaultRefreshHeader.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit
import MJRefresh

class XDDefaultRefreshHeader: MJRefreshHeader {

    private var refreshImage = UIImageView()
    
    private let refreshImages: [String: UIImage] = [
        "i_refresh_idle_1": UIImage(named: "i_refresh_idle_1")!,
        "i_refresh_idle_2": UIImage(named: "i_refresh_idle_2")!,
        "i_refresh_idle_3": UIImage(named: "i_refresh_idle_3")!,
        "i_refresh_idle_4": UIImage(named: "i_refresh_idle_4")!,
        "i_refresh_pulling": UIImage(named: "i_refresh_pulling")!,
        "i_refreshing": UIImage(named: "i_refreshing")!
    ]
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                if refreshImage.layer.animationKeys() != nil {
                    refreshImage.layer.removeAllAnimations()
                    refreshImage.transform = CGAffineTransform.identity
                }
                
                setImages("i_refresh_idle_1")
                
            case .pulling:
                setImages("i_refresh_pulling")
                
            case .refreshing:
                setImages("i_refreshing")
                
                let layer = CABasicAnimation()
                layer.keyPath = "transform.rotation.z"
                layer.toValue = 2.0 * Double.pi
                layer.duration = 1
                layer.repeatCount = Float.greatestFiniteMagnitude
                layer.isRemovedOnCompletion = false
                refreshImage.layer.add(layer, forKey: "rotationZ")
                
            default: break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            if state == .idle {
                if pullingPercent >= 0 && pullingPercent < 0.5 {
                    setImages("i_refresh_idle_1")
                } else if pullingPercent >= 0.5 && pullingPercent < 0.65 {
                    setImages("i_refresh_idle_2")
                } else if pullingPercent >= 0.65 && pullingPercent < 0.85 {
                    setImages("i_refresh_idle_3")
                } else if pullingPercent >= 0.85 && pullingPercent < 1.0 {
                    setImages("i_refresh_idle_4")
                }
                
                if pullingPercent < 0.5 {
                    refreshImage.alpha = pullingPercent / 0.5
                    refreshImage.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
                    refreshImage.center = CGPoint(x: mj_w/2, y: mj_h*0.75)
                } else {
                    refreshImage.alpha = 1.0
                    refreshImage.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
                    refreshImage.center = CGPoint(x: mj_w/2, y: mj_h-mj_h*pullingPercent/2)
                }
            } else {
                refreshImage.center = CGPoint(x: mj_w/2, y: mj_h/2)
                refreshImage.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            }
        }
    }
    
    
    override func prepare() {
        super.prepare()
        
        mj_h = 80.0
        backgroundColor = UIColor.clear
        
        addSubview(refreshImage)
        
        tintColor = .themeYellow
    }
    
    override func placeSubviews() {
        super.placeSubviews()
    }
    
    private func setImages(_ key: String) {
        let image = refreshImages[key]
        
        if image != refreshImage.image {
            refreshImage.image = image
            refreshImage.switchColor(tintColor)
        }
    }
}
