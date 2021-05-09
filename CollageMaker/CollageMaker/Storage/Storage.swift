//
//  Storage.swift
//  CollageMaker
//
//  Created by Alex on 12/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol StorageDelegate: class {
    func storageDidChangeContent()
}

class Storage: SelectionBagDelegate {

    static let shared = Storage()
    let selectedPhotosBag: SelectionBag
    let layoutManager = LayoutManager()
    
    weak var delegate: StorageDelegate?
    
    var selectedPhotos: [PhotoItem] {
        return selectedPhotosBag.items
    }
    
    private init() {
        selectedPhotosBag = SelectionBag()
        selectedPhotosBag.delegate = self
        layoutManager.selectedPhotosBag = selectedPhotosBag
    }
    
    //MARK: - SelectionBagDelegate
    
    func selectionBagDidChange() {
        delegate?.storageDidChangeContent()
    }
    
}
