//
//  PictureViewItemMock.swift
//  CollageMaker
//
//  Created by Alex on 2/6/21.
//  Copyright © 2021 Alex. All rights reserved.
//

import Foundation

class PictureViewItemMock: PictureViewItem, PhotoItemDelegate {
    weak var delegate: PictureViewItemDelegate?
    
    var image: UIImage? {
        return photoItem?.image
    }
    
    weak var photoItem: PhotoItem? {
        didSet {
            oldValue?.delegateCenter.remove(self)
            photoItem?.delegateCenter.add(self)
        }
    }
    
    var cropRect: CGRect = .zero
    
    //MARK: - PhotoItemDelegate
    func photoItemContentDidChange(_ photoItem: PhotoItem) {
        delegate?.pictureViewItemMockContentDidChange()
    }
}
