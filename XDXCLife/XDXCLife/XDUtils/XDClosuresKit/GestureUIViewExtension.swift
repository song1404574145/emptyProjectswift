//
//  GestureUIViewExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/5/9.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation
import UIKit

public extension UIView{
    @discardableResult
    func cs_addTapGesture(config: (_ gestureRecognizer:UITapGestureRecognizer) -> () = { _ in }) -> CSGesturePromise<UITapGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    func cs_whenTapped(handler: @escaping (_ tapGestureRecognizer: UITapGestureRecognizer)->()) {
        cs_addTapGesture().whenEnded(handler: handler)
    }
    
    @discardableResult
    func cs_addLongPressGesture(config:(_ gestureRecognizer: UILongPressGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UILongPressGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UILongPressGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    @discardableResult
    func cs_addPanGesture(config:(_ gestureRecognizer:UIPanGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UIPanGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UIPanGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    @discardableResult
    func cs_addSwipeGesture(config:(_ gestureRecognizer:UISwipeGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UISwipeGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UISwipeGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    func cs_whenSwipedInDirection(direction: UISwipeGestureRecognizer.Direction, gestureRecognizer: @escaping (_ gestureRecognizer:UISwipeGestureRecognizer)->()) {
        cs_addSwipeGesture { (swipeGestureRecognizer) in
            swipeGestureRecognizer.direction=direction
        }.whenEnded(handler: gestureRecognizer)
    }
    
    @discardableResult
    func cs_addPinchGesture(config:(_ gestureRecognizer:UIPinchGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UIPinchGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UIPinchGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    @discardableResult
    func cs_addRotationGesture(config:(_ gestureRecognizer:UIRotationGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UIRotationGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UIRotationGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
    
    @discardableResult
    func cs_addScreenEdgePanGesture(config:(_ gestureRecognizer:UIScreenEdgePanGestureRecognizer)->() = { _ in }) -> CSGesturePromise<UIScreenEdgePanGestureRecognizer> {
        isUserInteractionEnabled = true
        let recognizer = UIScreenEdgePanGestureRecognizer(config: config)
        addGestureRecognizer(recognizer)
        return recognizer.promise
    }
}
