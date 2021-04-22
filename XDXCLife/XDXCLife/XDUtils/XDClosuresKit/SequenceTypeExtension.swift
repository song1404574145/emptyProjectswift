//
//  SequenceTypeExtension.swift
//  ClosuresKit
//
//  Created by 卓同学 on 16/4/22.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import Foundation

extension Sequence {
    
    /**
     loops through the sequeence to find the match element
     it's will stop and return on the first match
     if thers isn't any element match, return nil
     */
    public func cs_match( condition:(Element) throws -> Bool) rethrows -> Element? {
        for element in self {
            if try condition(element) {
                return element
            }
        }
        return nil
    }
    
    /**
     Loops through the sequeence to find whether any object matches the closure.
     
     */
    public func cs_any(condition:(Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try condition(element) {
                return true
            }
        }
        return false
    }
    
    
    /** 
     Loops through an sequeence to find whether all element match the closure
     
     */
    public func cs_all(condition:(Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try !condition(element) {
                return false
            }
        }
        return true
    }
    
    /**
     Loops through an sequeence to find whether no element match the closure
     
     */
    public func cs_none(condition:(Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try condition(element) {
                return false
            }
        }
        return true
    }
}
