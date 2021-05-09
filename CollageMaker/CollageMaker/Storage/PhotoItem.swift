//
//  PhotoItem.swift
//  CollageMaker
//
//  Created by Alex on 12/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Photos

enum ImageType {
    case large
    case small
}

protocol PhotoItemDelegate: class {
    func photoItemContentDidChange(_ photoItem: PhotoItem)    
}

class PhotoItem: NSObject, CollectionViewItem {
    
    let id: Int
    var image: UIImage?
    let asset: PHAsset?
    
    let delegateCenter = DelegatesCenter<PhotoItemDelegate>()
    weak var cache: NSCache<NSObject, UIImage>?
    
    var isSelected: Bool = false {
        didSet {
            notifyDelegatesContentDidChange()
        }
    }
    
    init(with asset: PHAsset?, id: Int) {
        self.asset = asset
        self.id = id
    }
    
    func setOriginalImage(_ image: UIImage?) {
        self.image = image
    }
    
    var previewImage: UIImage? {
        return imagesStackManager?.image(for: self)
    }
    
    //MARK: - PRIVATE
    
    weak var imagesStackManager: ImagesStackManager?
    
    func collectionViewWillDisplay() {
        imagesStackManager?.requestImage(for: self)
    }
    
    func collectionViewDidEndDisplaying() {
        imagesStackManager?.cancelImageRequest(for: self)
    }
    
    func imagesStackManagerDidLoadContent() {
        DispatchQueue.main.async {[weak self] in
            self?.notifyDelegatesContentDidChange()
        }
    }
    
    private func notifyDelegatesContentDidChange() {
        delegateCenter.call { [weak self](listener) in
            guard let s = self else { return }
            listener.photoItemContentDidChange(s)
        }
    }
    
    func requestImage(type: ImageType, completion: @escaping ((_ image: UIImage) -> Void)) {
        guard let asset = asset else {
            return
        }

        let options = PHImageRequestOptions()
        options.version = .current
        options.isNetworkAccessAllowed = (type == .large)
        let imageSize = (type == .large) ? CGSize(width: 2000, height: 2000) : CGSize(width: 200, height: 200)

        PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options) {(image, propertiesDict) in
            if let image = image {
                completion(image)
            }
        }
    }
}
