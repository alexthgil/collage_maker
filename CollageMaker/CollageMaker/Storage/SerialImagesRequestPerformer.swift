//
//  SerialImagesRequestPerformer.swift
//  CollageMaker
//
//  Created by Alex on 2/6/21.
//  Copyright © 2021 Alex. All rights reserved.
//

import Foundation

class SerialImagesRequestPerformer {
    
    private var items = Set<PhotoItem>()
    private let requestsQ: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private var completion: (() -> Void)?
    
    func requestImages(for items: Set<PhotoItem>, completion: @escaping (() -> Void)) {
        self.items = items
        self.completion = completion
        processNextItem()
    }
    
    private func nextItemForImageRequest() -> PhotoItem? {
        var item: PhotoItem?
        let itemsCount = items.count
        if itemsCount > 0 {
            item = items.removeFirst()
        }
        return item
    }
    
    func processNextItem() {
        requestsQ.addOperation {[weak self] in
            if let item = self?.nextItemForImageRequest() {
                item.requestImage(type: .large, completion: { (image) in
                    item.setOriginalImage(image)
                    self?.processNextItem()
                })
            } else {
                self?.completion?()
            }
        }
    }
    
}
