//
//  ObserverNotificationExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/4/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation

private var CSNotificationHandlersKey = "CSNotificationHandlers"

extension NSObject{
    
    public typealias csNotificationHandler = (_ notification:NSNotification)->Void
    
    public func cs_addNotificationObserverForName(name aName: String, object anObject: AnyObject?,handler:@escaping csNotificationHandler){
        NotificationCenter.default.addObserver(self, selector:#selector(NSObject.notificationHandler(notification:)), name: NSNotification.Name(rawValue: aName), object: anObject)
        csNotificationHandlers[aName]=handler
    }
    
    public func cs_removeNotificationObserverForName(name aName:String){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: aName), object: nil)
    }
    
    @objc func notificationHandler(notification:NSNotification){
        if let handler = csNotificationHandlers[notification.name.rawValue]{
            handler(notification)
        }
    }
    
    // MARK: - computed propery
    private var csNotificationHandlers:[String:csNotificationHandler]{
        get{
            return handlerContainer.handlers
        }
        set{
            handlerContainer.handlers=newValue
        }
    }
    
    private var handlerContainer:NotificationHandlerContainer{
        get{
            if let container = cs_associateValueForKey(key: &CSNotificationHandlersKey) as? NotificationHandlerContainer {
                return container
            }else{
                let container = NotificationHandlerContainer()
                cs_associateValue(value: container, key: &CSNotificationHandlersKey)
                return container
            }
        }
    }
    
}

class NotificationHandlerContainer:NSObject{
    var handlers=[String:csNotificationHandler]()
}
