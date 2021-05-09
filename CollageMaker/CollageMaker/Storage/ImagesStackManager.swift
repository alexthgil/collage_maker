//
//  ImagesStackManager.swift
//  CollageMaker
//
//  Created by Alex on 2/6/21.
//  Copyright © 2021 Alex. All rights reserved.
//

import Foundation

class ImagesStackManager {
    
    private var cache = [Int:UIImage]()
    private var dataAccessLock = DispatchSemaphore(value: 1)
    private var itemsBatch = Set<PhotoItem>()

    private let requestsQ: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 4
        return q
    }()
    
    private var isWorkingLock = NSLock()
    var _isWorking: Bool = true
    var shouldStartProcessing: Bool {
        set {
            isWorkingLock.lock()
            _isWorking = newValue
            isWorkingLock.unlock()
        }
        
        get {
            isWorkingLock.lock()
            let copyIsWorking = _isWorking
            isWorkingLock.unlock()
            return copyIsWorking
        }
    }
    
    func save(image: UIImage, item: PhotoItem) {
        dataAccessLock.wait()
        cache[item.id] = image
        dataAccessLock.signal()
    }
    
    func removeImage(for item: PhotoItem) {
        dataAccessLock.wait()
        cache[item.id] = nil
        dataAccessLock.signal()
    }
    
    func image(for item: PhotoItem) -> UIImage? {
        var img: UIImage?
        dataAccessLock.wait()
        img = cache[item.id]
        dataAccessLock.signal()
        if img != nil {
            return img
        }

        requestImage(for: item)
        return nil
    }
    
    private func nextItemForImageRequest() -> PhotoItem? {
        var item: PhotoItem?
        dataAccessLock.wait()
        let itemsCount = itemsBatch.count
        if itemsCount > 0 {
            item = itemsBatch.removeFirst()
        }
        dataAccessLock.signal()
        return item
    }
    
    func requestImage(for item: PhotoItem) {
        dataAccessLock.wait()
        itemsBatch.insert(item)
        dataAccessLock.signal()
        if shouldStartProcessing {
            processNextItem()
        }
    }
    
    func cancelImageRequest(for item: PhotoItem) {
        dataAccessLock.wait()
        itemsBatch.remove(item)
        cache[item.id] = nil
        dataAccessLock.signal()
    }

    func processNextItem() {
        requestsQ.addOperation {[weak self] in
            if let item = self?.nextItemForImageRequest() {
                item.requestImage(type: .small, completion: { (image) in
                    self?.save(image: image, item: item)
                    item.imagesStackManagerDidLoadContent()
                    self?.processNextItem()
                })
            } else {
                self?.shouldStartProcessing = true
            }
        }
    }
    
}
