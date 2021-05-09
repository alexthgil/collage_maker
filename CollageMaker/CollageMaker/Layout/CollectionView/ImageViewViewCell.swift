//
//  SelectLayoutCollectionViewCell.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Photos

class ImageViewViewCell: UICollectionViewCell, PhotoItemDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    weak var item: CollectionViewItem? {
        didSet {
            oldValue?.delegateCenter.remove(self)
            item?.delegateCenter.add(self)
            updateDispalyaing()
        }
    }
    
    func configure(with item: CollectionViewItem) {
        self.item = item
    }
    
    func updateDispalyaing() {
        guard let item = item else {
            return
        }
        
        imageView.image = item.previewImage
        let isSelected = item.isSelected
        checkImageView.isHidden = (isSelected == false)
        updateSelectedState(with: isSelected)
    }
    
    func photoItemContentDidChange(_ photoItem: PhotoItem) {
        if self.item === photoItem {
            updateDispalyaing()
        }
    }
    
    private func updateSelectedState(with newSelectedState: Bool) {
        if (newSelectedState) {
            let selectedStateLayer = CALayer()
            selectedStateLayer.frame = imageView.bounds
            selectedStateLayer.backgroundColor = UIColor.init(white: 0.3, alpha: 0.5).cgColor
            imageView.layer.addSublayer(selectedStateLayer)
        } else {
            if let imageViewSublayrs = imageView.layer.sublayers {
                for ivsl in imageViewSublayrs {
                    ivsl.removeFromSuperlayer()
                }
            }
        }
    }
    
    override func prepareForReuse() {
        item = nil
        updateDispalyaing()
    }
}
