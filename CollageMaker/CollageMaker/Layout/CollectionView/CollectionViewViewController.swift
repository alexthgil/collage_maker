//
//  SelectLayoutCollectionViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Photos

protocol CollectionViewItem: class {
    var previewImage: UIImage? { get }
    var isSelected: Bool { get }
    var delegateCenter: DelegatesCenter<PhotoItemDelegate> { get }
}

protocol CollectionViewDelegate: class {
    func collectionViewDidSelectItem(at index: Int)
    func collectionViewNumberOfItems() -> Int
    func collectionViewItem(at index: Int) -> CollectionViewItem
    func collectionViewDidEndDisplayingItem(at index: Int)
    func collectionViewWillDisplayItem(at index: Int)
}

struct CollectionViewConfig {
    let columsCount: Int
    let rowsCount: Int
    let pading: CGFloat
    let scrollDirection: UICollectionView.ScrollDirection
    let minimumInteritemSpacing: CGFloat
    let minimumLineSpacing: CGFloat
    let sectionInset: UIEdgeInsets
    let titleLabel: String?
}

class CollectionViewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: CollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ""
        titleLabel.isHidden = true
        collectionView.register(UINib(nibName: "ImageViewViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewViewCell")
    }
    
    func reloadData() {
        let isTitleLabelhidden = ((delegate?.collectionViewNumberOfItems() ?? 0) > 1)
        titleLabel.isHidden = isTitleLabelhidden
        if isTitleLabelhidden == false {
            if let tlText = config.titleLabel {
                titleLabel.text = tlText
            } else {
                titleLabel.text = ""
                titleLabel.isHidden = true
            }
        }
        
        collectionView?.reloadData()
    }
    
    private var config: CollectionViewConfig = .init(columsCount: 1, rowsCount: 1, pading: 1, scrollDirection: .horizontal, minimumInteritemSpacing: 1, minimumLineSpacing: 1, sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), titleLabel: nil)
    
    func configure(with config: CollectionViewConfig) {
        self.config = config
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = config.scrollDirection
            flowLayout.minimumInteritemSpacing = config.minimumInteritemSpacing
            flowLayout.minimumLineSpacing = config.minimumLineSpacing
            flowLayout.sectionInset = config.sectionInset
        }
        
        collectionView.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .init(width: 100, height: 100)
        }
        
        let container = (collectionViewLayout.scrollDirection == .vertical) ? collectionView.bounds.size.width : collectionView.bounds.size.height
        let containerW = container - config.pading * 5
        let columsCount = (collectionViewLayout.scrollDirection == .vertical) ? CGFloat(config.columsCount) : 1
        if config.scrollDirection == .vertical {
            let w = containerW / columsCount
            let h = w / 1.3
            return CGSize(width: w, height: h)
        } else {
            let h = collectionView.bounds.size.height - (collectionViewLayout.sectionInset.top + collectionViewLayout.sectionInset.bottom + collectionViewLayout.minimumLineSpacing * 2)
            let w = h * 1.3
            return CGSize(width: w, height: h)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.collectionViewNumberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewViewCell", for: indexPath) as? ImageViewViewCell, let item = delegate?.collectionViewItem(at: indexPath.item) {
            cell.configure(with: item)
            return cell
        }

        return ImageViewViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.collectionViewWillDisplayItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.collectionViewDidEndDisplayingItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewDidSelectItem(at: indexPath.item)
    }
}

