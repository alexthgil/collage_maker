//
//  SelectionBag.swift
//  CollageMaker
//
//  Created by Alex on 12/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol SelectionBagDelegate: class {
    func selectionBagDidChange()
}

class SelectionBag {
    
    private var bag = Set<PhotoItem>()
    
    weak var delegate: SelectionBagDelegate?
    
    func add(_ item: PhotoItem) {
        item.isSelected = true
        bag.insert(item)
        delegate?.selectionBagDidChange()
    }
    
    func remove(_ item: PhotoItem) {
        item.isSelected = false
        bag.remove(item)
        delegate?.selectionBagDidChange()
    }
    
    var count: Int {
        bag.count
    }
    
    var items: [PhotoItem] {
        return Array(bag)
    }
    
}
