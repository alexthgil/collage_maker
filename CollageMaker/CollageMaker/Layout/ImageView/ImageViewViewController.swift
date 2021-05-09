//
//  ImageViewViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

protocol ImageViewViewControllerDelegate: class {
    func cropRectDidChange(with newCropRect: CGRect)
}

class ImageViewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak private var bgScrollView : UIScrollView!
    @IBOutlet weak private var imageView : UIImageView!
    @IBOutlet weak private var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var progressView: UIActivityIndicatorView!
    
    weak var delegate: ImageViewViewControllerDelegate?
    
    private var imageSize: CGSize = CGSize(width: 1, height: 1)
    private var axis: Arrangement = .horizontal
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        let minScale = bgScrollView.bounds.size.height / imageView.bounds.size.height;
        bgScrollView.minimumZoomScale = minScale
        bgScrollView.maximumZoomScale = 3.0
        bgScrollView.zoomScale = minScale
        bgScrollView.delegate = self
        updateProgressIndicatorShouldStart(true)
   }
    
    func configure(with item: PictureViewItem, axis: Arrangement) {
        self.axis = axis
        let image = item.image
        updateProgressIndicatorShouldStart(image == nil)

        if let image = image {
            imageSize = image.size
            imageViewWidthConstraint.constant = image.size.width
            imageViewHeightConstraint.constant = image.size.height
            bgScrollView.contentSize = imageView.bounds.size
            bgScrollView.maximumZoomScale = 3.0
            imageView.image = image
            updateDisplayingContent()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateDisplayingContent()
        updateCropRect()
    }
    
    private func updateDisplayingContent() {
        let isHorizontal = (axis == .horizontal)
        let bgScrollViewSide = isHorizontal ? bgScrollView.bounds.size.height : bgScrollView.bounds.size.width
        let imgSide = isHorizontal ? imageSize.height : imageSize.width
        
        let minScale = bgScrollViewSide / imgSide
        var zoomScale = minScale
        if isHorizontal {
            zoomScale = bgScrollView.bounds.size.width / imageSize.width
        } else {
            zoomScale = bgScrollView.bounds.size.height / imageSize.height
        }

        bgScrollView.minimumZoomScale = minScale
        bgScrollView.zoomScale = zoomScale
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCropRect()
    }
    
    private func updateCropRect() {
        let scale:CGFloat = 1/bgScrollView.zoomScale
        let x:CGFloat = bgScrollView.contentOffset.x * scale
        let y:CGFloat = bgScrollView.contentOffset.y * scale
        let width = (self.view.superview?.bounds.size.width ?? 1) * scale
        let height = (self.view.superview?.bounds.size.height ?? 1) * scale
        let dRect = CGRect(x: x, y: y, width: width, height: height)
        delegate?.cropRectDidChange(with: dRect)
    }

    private func updateProgressIndicatorShouldStart(_ state: Bool) {
        if state {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
}
