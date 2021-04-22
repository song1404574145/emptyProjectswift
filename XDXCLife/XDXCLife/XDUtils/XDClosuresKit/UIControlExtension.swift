//
//  UIControlExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/4/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit

private var CSControlEventsHandlerKey = "CSControlEventsHandlerKey"

extension UIControl {
    typealias CSEventContainerDict = [String: CSControlHandlerContainer]
    
    public func cs_addHandler(for event: UIControl.Event,handler: @escaping (_ sender:UIControl)->Void) {
        let container = CSControlHandlerContainer(handler: handler)
        handlers[event.cs_hashValue]=container
        addTarget(container, action: #selector(CSControlHandlerContainer.invoke(sender:)), for: event)
    }
    
    var handlers: CSEventContainerDict {
        set{
            cs_associateValue(value: newValue, key: &CSControlEventsHandlerKey)
        }
        get{
            if let container = cs_associateValueForKey(key: &CSControlEventsHandlerKey) as? CSEventContainerDict {
                return container
            }else{
                let container = [String:CSControlHandlerContainer]()
                cs_associateValue(value: container, key: &CSControlEventsHandlerKey)
                return container
            }
        }
    }
    
}

class CSControlHandlerContainer: NSObject {
    var handler:(UIControl)->Void = { _ in }
    
    init(handler: @escaping (_ sender:UIControl)->Void) {
        self.handler = handler
        super.init()
    }
    
    @objc func invoke(sender:UIControl) {
        handler(sender)
    }
}

extension UIControl.Event {
    var cs_hashValue: String {
        get {
            return String(self.rawValue)
        }
    }
}
