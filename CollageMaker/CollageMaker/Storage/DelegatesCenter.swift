//
//  DelegatesCenter.swift
//  CollageMaker
//
//  Created by Alex on 12/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class DelegatesCenter<T> {
    
    private class WeakDelegate: NSObject {
        weak var object: AnyObject?
        
        init(_ object: AnyObject) {
            self.object = object
        }
    }
    
    private var delegates = Set<WeakDelegate>()
    
    func add(_ obj: T) {
        if let obj = obj as? AnyObject {
            let d = WeakDelegate(obj)
            delegates.insert(d)
        } else {
            assert(false)
        }
    }
    
    func remove(_ obj: T) {
        if let obj = obj as? AnyObject {
            delegates = delegates.filter({ (d) -> Bool in
                return (d !== obj)
            })
        }
    }
    
    func call(_ action: @escaping (T) -> Void) {
        
        var nilDelegates = Set<WeakDelegate>()
        
        for d in delegates {
            if let obj = d.object as? T {
                action(obj)
            } else {
                nilDelegates.insert(d)
            }
        }
        
        for nd in nilDelegates {
            delegates.remove(nd)
        }
    }
}
