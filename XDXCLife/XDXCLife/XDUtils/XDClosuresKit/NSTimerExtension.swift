//
//  NSTimerExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/4/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation

private var CSTimerHandlerKey = "CSTimerHandlerKey"

public extension Timer {
    class func cs_scheduledTimerWithTimeInterval(timeInterval: TimeInterval, userInfo: Any? = nil, repeats: Bool = true, mode: RunLoop.Mode = .common, handler: @escaping (_ timer: Timer) -> Void) -> Timer {
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(Timer.timerHandler(timer:)), userInfo: userInfo, repeats: repeats)
        timer.handler = handler
        
        RunLoop.current.add(timer, forMode: mode)
        return timer
    }
    
    /// 计时器暂停
    func pause() {
        fireDate = Date.distantFuture
    }
    
    /// 计时器继续
    func resumed() {
        fireDate = Date.distantPast
    }
    
    /// 释放timer
    func deinitTimer() {
        pause()
        invalidate()
    }
    
    @objc class func timerHandler(timer: Timer) {
        timer.handler(timer)
    }
    
    // MARK: - computed propery
    private var handler:(_ timer:Timer) -> Void {
        get {
            return timeHandlerContainer.handler
        }
        set {
            timeHandlerContainer.handler = newValue
        }
    }
    
    private var timeHandlerContainer: NSTimerHandlerContainer {
        get {
            if let container = cs_associateValueForKey(key: &CSTimerHandlerKey) as? NSTimerHandlerContainer {
                return container
            } else {
                let container = NSTimerHandlerContainer()
                cs_associateValue(value: container, key: &CSTimerHandlerKey)
                return container
            }
        }
    }
}

class NSTimerHandlerContainer: NSObject {
    var handler:(_ timer:Timer)->Void = { _ in }
}
