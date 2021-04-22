//
//  UIGesturePromiseExntension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/5/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation
import UIKit

public protocol CSGesturePromisable: class {
    
}

private var CSGesturePromisableKey = "CSGesturePromisableKey"

extension CSGesturePromisable where Self: UIGestureRecognizer {
    var promise: CSGesturePromise<Self> {
        get{
            if let container = cs_associateValueForKey(key: &CSGesturePromisableKey) as? CSGesturePromise<Self> {
                return container
            }else{
                let container = CSGesturePromise<Self>()
                
                cs_associateValue(value: container, key: &CSGesturePromisableKey)
                return container    
            }
        }
        set{
            cs_associateValue(value: newValue, key: &CSGesturePromisableKey)
        }
    }
    
    init(config: (_ gestureRecognizer: Self) -> () = { _ in }) {
        typealias Gesture = Self
        let promise=CSGesturePromise<Gesture>()
        
        self.init(target: promise, action: #selector(CSGesturePromise.gesureRecognizerHandler(gestureRecognizer:)))
        self.promise = promise
        config(self)
    }
}

extension UITapGestureRecognizer:CSGesturePromisable{
    
}

extension UILongPressGestureRecognizer:CSGesturePromisable{
    
}

extension UIPanGestureRecognizer:CSGesturePromisable{
    
}

extension UISwipeGestureRecognizer:CSGesturePromisable{
    
}

extension UIRotationGestureRecognizer:CSGesturePromisable{
    
}

extension UIPinchGestureRecognizer:CSGesturePromisable{
    
}

