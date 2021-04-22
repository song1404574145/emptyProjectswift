//
//  WeakHighTimer.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/21.
//

import UIKit

class WeakHighTimer: NSObject {
    var timer: DispatchSourceTimer?
    private var isRunning = false
    private var timeInterval: DispatchTimeInterval = .seconds(60)
    private var leeway: DispatchTimeInterval = .nanoseconds(0)
    private weak var delegate: AnyObject?
    private var targetName = ""
    
    convenience init(timeInterval: DispatchTimeInterval, target: AnyObject, selector: Selector, leeway: DispatchTimeInterval = .nanoseconds(0)) {
        self.init()
        delegate = target
        
        self.timeInterval = timeInterval
        self.leeway = leeway
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.setEventHandler(handler: { [weak self] in
            _ = self?.delegate?.perform(selector)
        })
        
        targetName = String(describing: type(of: target))
    }
    
    /// 开始 (等待 timeInterval 秒后开始执行, 如果需要立即执行的话,请自己调用 target 下的 selector 方法)
    func start() {
        if isRunning == false {
            isRunning = true
            timer?.schedule(wallDeadline: .now() + timeInterval, repeating: timeInterval, leeway: leeway)
            timer?.resume()
        }
    }
    
    /// 暂停
    func pause() {
        if isRunning == true {
            isRunning = false
            timer?.schedule(wallDeadline: .distantFuture)
            timer?.suspend()
        }
    }
    
    /// 释放timer
    func deinitTimer() {
        if isRunning == false {
            isRunning = true
            timer?.resume()
        }
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        print("WeakTimer 释放 -> target:\(String(describing: delegate)) targetName:\(targetName)")
    }
}
