//
//  BasicConfigViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

protocol BasicConfigDelegate: class {
    func userDidSelectLayout(at index: Int)
}

class BasicConfigViewController: UIViewController, SelectLayoutCollection {

    @IBOutlet private weak var layoutVariantsContainer: UIView!
    @IBOutlet private weak var picturesSelectorContainer: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var delegate: BasicConfigDelegate?
    
    private let selectLayoutCollectionViewController = SelectLayoutCollectionViewController()
    private let picturesCollectionViewController = PicturesCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLayoutCollectionViewController.delegate = self
        selectLayoutCollectionViewController.view.frame = layoutVariantsContainer.bounds
        layoutVariantsContainer.addSubview(selectLayoutCollectionViewController.view)
        
        picturesCollectionViewController.view.frame = picturesSelectorContainer.bounds
        picturesSelectorContainer.addSubview(picturesCollectionViewController.view)
    }
    
    func configure() {
        selectLayoutCollectionViewController.configure()
        picturesCollectionViewController.configure()
    }
    
    //MARK: - SelectLayoutCollection
    
    func userDidSelectLayout(at index: Int) {
        delegate?.userDidSelectLayout(at: index)
    }
    
}
