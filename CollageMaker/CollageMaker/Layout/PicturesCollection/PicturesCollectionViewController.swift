//
//  SelectLayoutCollectionViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Photos

class PicturesCollectionViewController: UIViewController, CollectionViewDelegate, PhotosLibraryDelegate {

    private let selectionBag = SelectionBag()
    private let collection = CollectionViewViewController()
    private let cache = NSCache<PHAsset, UIImage>()

    func configure() {
        let config = CollectionViewConfig(columsCount: 4,
                                          rowsCount: 4,
                                          pading: 2, scrollDirection: .vertical,
                                          minimumInteritemSpacing: 2,
                                          minimumLineSpacing: 2,
                                          sectionInset: .init(top: 2, left: 2, bottom: 2, right: 2), titleLabel: nil)
        collection.configure(with: config)
        collection.reloadData()
    }
    
    func collectionViewNumberOfItems() -> Int {
        return PhotosLibrary.shared.photosCount
    }
    
    func collectionViewItem(at index: Int) -> CollectionViewItem {
        return PhotosLibrary.shared.photoItem(at: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
        collection.view.frame = view.bounds
        view.addSubview(collection.view)
        
        PhotosLibrary.shared.delegatesCenter.add(self)
    }
    
    func photosLibraryDidCahngeContent() {
        DispatchQueue.main.async { [weak self] in
            self?.collection.reloadData()
        }
    }
    
    //MARK: - CollectionViewDelegate
    
    func collectionViewDidEndDisplayingItem(at index: Int) {
        let item = PhotosLibrary.shared.photoItem(at: index)
        item.collectionViewDidEndDisplaying()
    }
    
    func collectionViewWillDisplayItem(at index: Int) {
        let item = PhotosLibrary.shared.photoItem(at: index)
        item.collectionViewWillDisplay()
    }
    
    func collectionViewDidSelectItem(at index: Int) {
        let item = PhotosLibrary.shared.photoItem(at: index)
        
        if item.isSelected == false {
            let selectedBag = Storage.shared.selectedPhotosBag
            let selectedCount = selectedBag.count
            if selectedCount < 4 {
                selectedBag.add(item)
            }
        } else {
            Storage.shared.selectedPhotosBag.remove(item)
        }
    }
}
