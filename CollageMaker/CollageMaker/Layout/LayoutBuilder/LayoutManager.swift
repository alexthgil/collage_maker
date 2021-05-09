//
//  LayoutManager.swift
//  CollageMaker
//
//  Created by Alex on 12/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol LayoutManagerDelegate: class {
    func layoutManagerDidChangeContent()
}

class LayoutManager: SelectionBagDelegate {

    weak var delegate: LayoutManagerDelegate?
    private let builder = LayoutBuilder()
    weak var selectedPhotosBag: SelectionBag? {
        didSet {
            oldValue?.delegate = nil
            selectedPhotosBag?.delegate = self
        }
    }

    private var layoutsBatch = [LayoutCouple]()
    
    var count: Int {
        return layoutsBatch.count
    }
    
    func layout(at index: Int) -> LayoutCouple? {
        if 0 <= index && index < layoutsBatch.count {
            return layoutsBatch[index]
        } else {
            return nil
        }
    }
    
    func refreshLayoutsBatch() {
        guard let selectedPhotosBag = selectedPhotosBag else {
            layoutsBatch = []
            return
        }
        
        layoutsBatch = builder.build(from: selectedPhotosBag.items)
    }
    
    //MARK: - SelectionBagDelegate
    
    func selectionBagDidChange() {
        refreshLayoutsBatch()
        delegate?.layoutManagerDidChangeContent()
    }
    
}
