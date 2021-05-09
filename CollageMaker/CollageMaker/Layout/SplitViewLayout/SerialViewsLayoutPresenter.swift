//
//  SerialViewsLayoutPresenter.swift
//  CollageMaker
//
//  Created by Alex on 10/24/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

protocol AtomPresenter: class {
    var view: UIView { get }
}

enum Arrangement {
    case horizontal
    case vertical
}

protocol SerialViewsLayoutSelectionDelegate: class {
    func serialViewsLayoutBuildChild(_ child: AtomPresenter)
}

class SerialViewsLayoutPresenter: NSObject, AtomPresenter, SerialViewsLayoutSelectionDelegate {
    
    weak var serialViewsDelegate: SerialViewsLayoutSelectionDelegate?
    private var model: LayoutCouple?
    private var children = Set<SerialViewsLayoutPresenter>()
    private var secondP: PictureViewItem?

    let vc = SerialViewsLayoutViewController(nibName: "SerialViewsLayoutViewController", bundle: nil)
    private var firstItem: AtomPresenter? {
        didSet {
            if let firstItem = firstItem {
                vc.configure(withFirst: firstItem)
            }
        }
    }
    private var secondItem: AtomPresenter? {
        didSet {
            if let secondItem = secondItem {
                vc.configure(withSecond: secondItem)
            }
        }
    }
    
    override init() {
        _ = vc.view
    }
    
    func configure(with model: LayoutCouple) {
        self.model = model
        vc.config(with: model)
        
        let mf = (model.arrangement == .horizontal) ? model.first : model.second
        let ms = (model.arrangement == .horizontal) ? model.second : model.first
        firstItem = buildLayoutItem(item: mf, axis: model.arrangement)
        secondItem = buildLayoutItem(item: ms, axis: model.arrangement)
    }
    
    private func buildLayoutItem(item: LayoutItem, axis: Arrangement) -> AtomPresenter {
        switch item {
        case .couple(let couple):
            let item = SerialViewsLayoutPresenter()
            item.serialViewsDelegate = self
            if let serialViewsDelegate = serialViewsDelegate {
                serialViewsDelegate.serialViewsLayoutBuildChild(item)
            } else {
                children.insert(item)
            }

            item.configure(with: couple)
            return item
            
        case .picture(let picItem):
            let pvp = ImageViewPresentor()
            pvp.configure(with: picItem, axis: axis)
            return pvp
        }
    }
    
    func serialViewsLayoutBuildChild(_ child: AtomPresenter) {
        if let child = child as? SerialViewsLayoutPresenter {
            children.insert(child)
        }
    }
    
    //MARK: - AtomPresenter
    
    var view: UIView {
        return vc.view
    }

}

