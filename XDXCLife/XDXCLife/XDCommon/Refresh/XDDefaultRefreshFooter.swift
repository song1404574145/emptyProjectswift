//
//  XDDefaultRefreshFooter.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit
import MJRefresh

class XDDefaultRefreshFooter: MJRefreshBackStateFooter {

    var loadImage = UIImageView()
    var loadLabel = UILabel()
    
    private let loadImages: [String: UIImage] = [
        "i_load_arrow": UIImage(named: "i_load_arrow")!,
        "i_refreshing": UIImage(named: "i_refreshing")!,
        "i_refresh_pulling": UIImage(named: "i_refresh_pulling")!
    ]
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                setImages("i_load_arrow")
                loadLabel.text = "上拉即可加载"
                
                if oldValue == .pulling {
                    let layer = CABasicAnimation()
                    layer.keyPath = "transform.rotation.z"
                    layer.fromValue = Double.pi
                    layer.toValue = 0
                    layer.duration = 0.5
                    layer.fillMode = .forwards
                    layer.isRemovedOnCompletion = false
                    loadImage.layer.add(layer, forKey: "idle")
                } else {
                    loadImage.layer.removeAllAnimations()
                    loadImage.transform = CGAffineTransform.identity
                }
                
            case .pulling:
                setImages("i_load_arrow")
                loadLabel.text = "松手即可加载"
                
                let layer = CABasicAnimation()
                layer.keyPath = "transform.rotation.z"
                layer.fromValue = 0
                layer.toValue = Double.pi
                layer.duration = 0.5
                layer.fillMode = .forwards
                layer.isRemovedOnCompletion = false
                loadImage.layer.add(layer, forKey: "pulling")
                
            case .refreshing:
                setImages("i_refreshing")
                loadLabel.text = "正在加载中"
                
                let layer = CABasicAnimation()
                layer.keyPath = "transform.rotation.z"
                layer.toValue = 2.0 * Double.pi
                layer.duration = 1
                layer.repeatCount = Float.greatestFiniteMagnitude
                layer.isRemovedOnCompletion = false
                loadImage.layer.add(layer, forKey: "refreshing")
                
            case .noMoreData:
                loadImage.isHidden = true
                loadLabel.text = "已经到底啦"
                
            default: break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            if pullingPercent < 0.4 {
                alpha = 0
            } else {
                alpha = 1.0
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        stateLabel?.isHidden = true
        
        alpha = 0
        mj_h = 80.0
        backgroundColor = UIColor.clear
        
        addSubview(loadImage)
        
        loadLabel.font = UIFont.systemFont(ofSize: 14)
        loadLabel.textColor = UIColor.color0x666666
        addSubview(loadLabel)
        
        tintColor = .themeYellow
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        loadImage.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        loadImage.center = CGPoint(x: (mj_w-130)/2+10, y: mj_h/2)
        loadLabel.frame = CGRect(x: (mj_w-130)/2+30, y: mj_h/2-10, width: 100, height: 20)
    }
    
    private func setImages(_ key: String) {
        let image = loadImages[key]
        
        if image != loadImage.image {
            loadImage.isHidden = false
            loadImage.image = image
            loadImage.switchColor(tintColor)
        }
    }

}
