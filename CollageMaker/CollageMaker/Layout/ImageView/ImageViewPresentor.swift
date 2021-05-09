//
//  ImageViewPresentor.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

protocol PictureViewItemDelegate: class {
    func pictureViewItemMockContentDidChange()
}

protocol PictureViewItem: class {
    var photoItem: PhotoItem? { get }
    var image: UIImage? { get }
    var delegate: PictureViewItemDelegate? { get set }
    var cropRect: CGRect { get set }
}

class ImageViewPresentor: AtomPresenter, PictureViewItemDelegate, ImageViewViewControllerDelegate {

    private let vc: ImageViewViewController
    private weak var parentContainer: UIView?
    private weak var item: PictureViewItem?
    private var axis: Arrangement = .horizontal
    
    init() {
        vc = ImageViewViewController()
        vc.delegate = self
        _ = vc.view
    }
    
    func configure(with item: PictureViewItem, axis: Arrangement) {
        self.item = item
        self.axis = axis
        item.delegate = self
        vc.configure(with: item, axis: axis)
    }
    
    //MARK: - AtomPresenter
    
    var view: UIView {
        return vc.view
    }
    
    //MARK: - ImageViewViewControllerDelegate
    
    func cropRectDidChange(with newCropRect: CGRect) {
        item?.cropRect = newCropRect
    }
    
    //MARK: -
    
    internal func pictureViewItemMockContentDidChange() {
        guard let item = item else {
            return
        }
        vc.configure(with: item, axis: axis)
    }
    
}
