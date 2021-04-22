//
//  NSObjectAssociatedExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/4/24.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation

extension NSObject{
    
    // MARK: - retain
    /**
     Strongly associates an object with the reciever.
     
     */
    public func cs_associateValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /**
     Strongly associates an object with the reciever.
     
     */
    public class func cs_associateValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /**
     Strongly, thread-safely associates an object with the reciever.
     
     */
    public func cs_atomicallyAssociateValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /**
     Strongly, thread-safely associates an object with the reciever.
     
     */
    public class func cs_atomicallyAssociateValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    
    // MARK: - copy
    /**
     Associates a copy of an object with the reciever.
     
     */
    public func cs_associateCopyOfValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    /**
     Associates a copy of an object with the reciever.
     
     */
    public class func cs_associateCopyOfValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    /**
     Thread-safely associates a copy of an object with the reciever.
     
     */
    public func cs_atomicallyAassociateCopyOfValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY)
    }
    
    /**
     Thread-safely associates a copy of an object with the reciever.
     
     */
    public class func cs_atomicallyAssociateCopyOfValue(value: Any, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY)
    }
    
    // MARK: - weak
    
    /**
     Weakly associates an object with the reciever.
     
     */
    public func cs_weaklyAssociateValue(value: Any, key: UnsafeRawPointer) {
        var assocObject = objc_getAssociatedObject(self, key) as? _CSWeakAssociatedObject
        if assocObject == nil {
            assocObject=_CSWeakAssociatedObject()
            cs_associateValue(value: assocObject!, key: key)
        }
        assocObject!.value = value
    }
    
    /**
     Weakly associates an object with the reciever.
     
     */
    public class func cs_weaklyAssociateValue(value: Any, key: UnsafeRawPointer) {
        var assocObject = objc_getAssociatedObject(self, key) as? _CSWeakAssociatedObject
        if assocObject == nil {
            assocObject=_CSWeakAssociatedObject()
            cs_associateValue(value: assocObject!, key: key)
        }
        assocObject!.value = value
    }
    
    
    // MARK: - get associate Value
    public func cs_associateValueForKey(key:UnsafeRawPointer) -> Any? {
        let value = objc_getAssociatedObject(self, key)
        if value != nil && value is _CSWeakAssociatedObject{
            if let _value = (value as? _CSWeakAssociatedObject)?.value {
                return _value
            }else{
                preconditionFailure("value is nil")
            }
        }
        return value
    }
    
    public class func cs_associateValueForKey(key: UnsafeRawPointer) -> Any? {
        let value = objc_getAssociatedObject(self, key)
        if value != nil && value is _CSWeakAssociatedObject {
            if let _value = (value as? _CSWeakAssociatedObject)?.value {
                return _value
            }else{
                preconditionFailure("value is nil")
            }
        }
        return value
    }
    
    // MARK: - remove
    public func cs_removeAllAssociatedObjects(){
        objc_removeAssociatedObjects(self)
    }
    
    public class func cs_removeAllAssociatedObjects(){
        objc_removeAssociatedObjects(self)
    }
}

class _CSWeakAssociatedObject: NSObject {
    var value: Any?
}
