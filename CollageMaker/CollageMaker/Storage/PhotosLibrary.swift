//
//  PhotosLibrary.swift
//  CollageMaker
//
//  Created by Alex on 12/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol PhotosLibraryDelegate: class {
    func photosLibraryDidCahngeContent()
}

class PhotosLibrary {
   
    weak var delegate: PhotosLibraryDelegate?
    let delegatesCenter = DelegatesCenter<PhotosLibraryDelegate>()
    
    static let shared = PhotosLibrary()
    private init() {
        buildLibrary()
    }
    
    private let internalSerialQ: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private let cache = NSCache<NSObject, UIImage>()
    
    var photosCount: Int {
        return photoItems.count
    }
    
    func photoItem(at index: Int) -> PhotoItem {
        if 0 <= index && index < photosCount {
            return photoItems[index]
        }
        
        return PhotoItem(with: nil, id: 0)
    }
    
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    var photoItems = [PhotoItem]()
    
    private let imagesStackManager = ImagesStackManager()
    
    func fetchAssets() {
        internalSerialQ.addOperation {[weak self] in
            
            guard let s = self, s.authorizationStatus == PHAuthorizationStatus.authorized else {
                assert(false)
                return
            }
        
            let fetchOptions = PHFetchOptions()
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            for index in 0..<assets.count {
                let asset = assets.object(at: index)
                let photoItem = PhotoItem(with: asset, id: index)
                photoItem.imagesStackManager = self?.imagesStackManager
                _ = photoItem.previewImage
                photoItem.cache = s.cache
                s.photoItems.append(photoItem)
            }
                
            s.delegatesCenter.call { (delegate: PhotosLibraryDelegate) in
                delegate.photosLibraryDidCahngeContent()
            }
        }
    }
    
    func buildLibrary() {
        internalSerialQ.addOperation {[weak self] in
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
                self?.authorizationStatus = status
                self?.fetchAssets()
            }
        }
    }
}

