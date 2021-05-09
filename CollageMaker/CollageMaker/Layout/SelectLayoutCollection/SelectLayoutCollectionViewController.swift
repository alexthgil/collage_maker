//
//  SelectLayoutCollectionViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Photos

protocol SelectLayoutCollection: class {
    func userDidSelectLayout(at index: Int)
}

class SelectLayoutCollectionViewController: UIViewController, CollectionViewDelegate, LayoutManagerDelegate {
        
    weak var delegate: SelectLayoutCollection?
    private let collectionViewController = CollectionViewViewController()
    private let layoutManager = Storage.shared.layoutManager
    @IBOutlet weak private var contentContainerView: UIView?
    @IBOutlet weak private var helpLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutManager.delegate = self
        collectionViewController.delegate = self
        collectionViewController.view.frame = view.bounds
        contentContainerView?.addSubview(collectionViewController.view)
        
    }
    
    func configure() {
        let collectionViewConfig = CollectionViewConfig(columsCount: 2,
                                                        rowsCount: 2,
                                                        pading: 0,
                                                        scrollDirection: .horizontal,
                                                        minimumInteritemSpacing: 0,
                                                        minimumLineSpacing: 10,
                                                        sectionInset: .init(top: 0, left: 10, bottom: 0, right: 10),
                                                        titleLabel: "Select more photos")
        collectionViewController.configure(with: collectionViewConfig)
    }
    
    //MARK: - CollectionViewDelegate
    
    func collectionViewDidSelectItem(at index: Int) {
        delegate?.userDidSelectLayout(at: index)
    }

    func collectionViewNumberOfItems() -> Int {
        return layoutManager.count
    }

    func collectionViewItem(at index: Int) -> CollectionViewItem {
        let displayItem = LayoutDisplayItem()
        
        if let layoutModel = layoutManager.layout(at: index) {
            let rSize = CGSize(width: 260, height: 200)
            let exportManager = ExportManager(canvasSize: rSize)
            displayItem.previewImage = exportManager.exportImage(from: layoutModel, operationType: .usePreviewImageAndCropToCenter(.init(origin: .zero, size: rSize)))
        }
        
        return displayItem
    }
    
    func collectionViewDidEndDisplayingItem(at index: Int) {
        
    }
    
    func collectionViewWillDisplayItem(at index: Int) {
        
    }
    
    //MARK: - LayoutManagerDelegate
    
    func layoutManagerDidChangeContent() {
        helpLabel?.isHidden = (layoutManager.count > 0)
        collectionViewController.reloadData()
    }
    
}

class LayoutDisplayItem: CollectionViewItem {
    
    var delegateCenter = DelegatesCenter<PhotoItemDelegate>()
    var previewImage: UIImage?
    var delegate: PhotoItemDelegate?
    var isSelected: Bool = false
    
}
