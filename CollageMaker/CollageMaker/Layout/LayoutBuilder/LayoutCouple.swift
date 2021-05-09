//
//  File.swift
//  CollageMaker
//
//  Created by Alex on 2/6/21.
//  Copyright © 2021 Alex. All rights reserved.
//

import Foundation

enum RenderOperationType {
    case useLargeImage
    case usePreviewImageAndCropToCenter(CGRect)
}

class LayoutCouple: NSObject {
    let first: LayoutItem
    let second: LayoutItem
    var arrangement: Arrangement = .horizontal
    var proportion: Float = 0.5
    var preferedSize = CGSize(width: 100, height: 100)
    
    init(first: LayoutItem, second: LayoutItem) {
        self.first = first
        self.second = second
    }
    
    func draw(at rect: CGRect, with drawer: PictureCompoundPerformer, operationType: RenderOperationType) {
        
        let fRect: CGRect
        let sRect: CGRect
        
        switch arrangement {
        case .horizontal:
            let aW: Int = Int(rect.size.width * CGFloat(proportion))
            let bW: Int = Int(rect.size.width) - aW
            let bX = rect.origin.x + CGFloat(aW)
            fRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: CGFloat(aW), height: rect.size.height)
            sRect = CGRect(x: bX, y: rect.origin.y, width: CGFloat(bW), height: rect.size.height)
        case .vertical:
            let bH: Int = Int(rect.size.height * CGFloat(proportion))
            let aH: Int = Int(rect.size.height) - bH
            let bY = rect.origin.y + CGFloat(aH)
            fRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(aH))
            sRect = CGRect(x: rect.origin.x, y: CGFloat(bY), width: rect.size.width, height: CGFloat(bH))
        }

        for item in [first, second] {
            let r = (item == first) ? fRect : sRect
            switch item {
            case .couple(let couple):
                couple.draw(at: r, with: drawer, operationType: operationType)
            case .picture(let pItem):
                switch operationType {
                case .useLargeImage:
                    if let img = buildImage(from: pItem, operationType: .useLargeImage) {
                        drawer.draw(img, at: r)
                    } else {
                        assert(false)
                    }
                case .usePreviewImageAndCropToCenter(let centerRect):
                    if let img = buildImage(from: pItem, operationType: .usePreviewImageAndCropToCenter(centerRect)) {
                        drawer.draw(img, at: r)
                    } else {
                        assert(false)
                    }
                }
            }
        }
    }
    
    func buildImage(from item: PictureViewItem, operationType: RenderOperationType) -> UIImage? {
        switch operationType {
        case .useLargeImage:
            if let img = item.photoItem?.image {
                let cropRect = item.cropRect
                return buildCropedImage(from: cropRect, sourceImage: img)
            }
        case .usePreviewImageAndCropToCenter(let rect):
            if let img = item.photoItem?.previewImage {
                let w = img.size.width / (img.size.width / rect.size.width)
                let h = min(img.size.height, rect.size.height)
                let y = abs((img.size.height - rect.size.height) / 2.0)
                let x = abs((img.size.width - rect.size.width) / 2.0)
                return buildCropedImage(from: CGRect(x: x, y: y, width: w, height: h), sourceImage: img)
            }
        }
        return nil
    }
    
    func collectItems() -> Set<PhotoItem> {
        var collection = Set<PhotoItem>()
        
        for item in [first, second] {
            switch item {
            case .couple(let couple):
                for mItem in couple.collectItems() {
                    collection.insert(mItem)
                }
            case .picture(let pItem):
                if let photoItem = pItem.photoItem {
                    collection.insert(photoItem)
                }
            }
        }
    
        return collection
    }
    
    func buildCropedImage(from rect: CGRect, sourceImage: UIImage) -> UIImage? {
        if let croppedCGImage = sourceImage.cgImage?.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage)
        } else {
            return nil
        }
    }
    
}
