//
//  NCGesturePromise.swift
//  NiceGesture
//
//  Created by 卓同学 on 16/4/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit

public class CSGesturePromise<T: UIGestureRecognizer>: NSObject {
    public typealias csGestureHandler = (_ gestureRecognizer: T) -> Void
    
    var beganHandler:       csGestureHandler = { _ in }
    var cancelledHandler:   csGestureHandler = { _ in }
    var changedHandler:     csGestureHandler = { _ in }
    var endedHandler:       csGestureHandler = { _ in }
    var failedHandler:      csGestureHandler = { _ in }
    
    
    @objc func gesureRecognizerHandler(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            beganHandler(gestureRecognizer as! T)
        case .cancelled:
            cancelledHandler(gestureRecognizer as! T)
        case .changed:
            changedHandler(gestureRecognizer as! T)
        case .ended:
            endedHandler(gestureRecognizer as! T)
        case .failed:
            failedHandler(gestureRecognizer as! T)
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    /**
     one handler for many states
     
     - parameter states:  UIGestureRecognizerStates
     
     */
    public func whenStatesHappend(states: [UIGestureRecognizer.State], handler: @escaping csGestureHandler) -> CSGesturePromise<T> {
        for state in states{
            switch state {
            case .began:
                beganHandler = handler
            case .cancelled:
                cancelledHandler = handler
            case .changed:
                changedHandler = handler
            case .ended:
                endedHandler = handler
            case .failed:
                failedHandler = handler
            case .possible:
                break
            @unknown default:
                break
            }
        }
        return self
    }
    
    @discardableResult
    public func whenBegan(handler: @escaping csGestureHandler) -> CSGesturePromise<T> {
        beganHandler = handler
        return self
    }
    
    @discardableResult
    public func whenCancelled(handler: @escaping csGestureHandler) -> CSGesturePromise<T> {
        cancelledHandler = handler
        return self
    }
    
    @discardableResult
    public func whenChanged(handler: @escaping csGestureHandler) -> CSGesturePromise<T> {
        changedHandler = handler
        return self
    }
    
    @discardableResult
    public func whenEnded(handler: @escaping csGestureHandler) -> CSGesturePromise<T> {
        endedHandler = handler
        return self
    }
    
    @discardableResult
    public func whenFailed(handler: @escaping csGestureHandler)->CSGesturePromise<T>{
        failedHandler = handler
        return self
    }
}
