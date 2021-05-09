//
//  SerialViewsLayoutViewController.swift
//  CollageMaker
//
//  Created by Alex on 10/24/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SerialViewsLayoutViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var firstContainerView: UIView!
    @IBOutlet private weak var secondContainerView: UIView!
    private var equalWidthConstraint: NSLayoutConstraint?
    private var startPoint: CGPoint? = CGPoint.zero
    private weak var firstItem: AtomPresenter?
    private weak var secondItem: AtomPresenter?
    private weak var model: LayoutCouple?

    private weak var selectedItem: AtomPresenter?
    private func select(item: AtomPresenter?) {
        selectedItem = item
    }
    
    private var controlView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
        }
    }
    
    private var arrangement: Arrangement = .horizontal {
        didSet {
            configureControl()
            updateControlDisplaying()
        }
    }
    
    private var proportion: CGFloat = 0.5 {
        didSet {
            model?.proportion = Float(proportion)
            updateControlDisplaying()
        }
    }
        
    private func configureControl() {
        updateControlForCurrentArrangement()
        
        switch arrangement {
        case .horizontal:
            stackView.axis = .horizontal
            configureControlConstrainstsForHorizontalArrangement()
        case .vertical:
            stackView.axis = .vertical
            configureControlConstrainstsForVerticalArrangement()
        }
    }
        
    private func updateControlForCurrentArrangement() {
        controlView = UIView()
        self.view.addSubview(controlView)
        controlView.layer.cornerRadius = 2
        controlView.backgroundColor = UIColor(red: 40.0 / 255.0, green: 122.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
        controlView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureControlConstrainstsForVerticalArrangement() {
        
        guard let firstContainerView = firstContainerView else {
             return
        }
        
        let leading = NSLayoutConstraint(item: controlView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20)
        self.view.addConstraint(leading)

        let trailing = NSLayoutConstraint(item: controlView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -20)
        self.view.addConstraint(trailing)
        
        let height = NSLayoutConstraint(item: controlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 10)
        controlView.addConstraint(height)
        
        let centerY = NSLayoutConstraint(item: controlView, attribute: .centerY, relatedBy: .equal, toItem: firstContainerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(centerY)
    }
    
    func configureControlConstrainstsForHorizontalArrangement() {

        guard let firstContainerView = firstContainerView else {
             return
        }
        
        let centerX = NSLayoutConstraint(item: controlView, attribute: .centerX, relatedBy: .equal, toItem: firstContainerView, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let width = NSLayoutConstraint(item: controlView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 10)
        controlView.addConstraint(width)
        
        let top = NSLayoutConstraint(item: controlView, attribute: .top, relatedBy: .equal, toItem: firstContainerView, attribute: .top, multiplier: 1.0, constant: 20)

        let bottom = NSLayoutConstraint(item: controlView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -20)
        
        self.view.addConstraints([centerX, width, top, bottom])
    }
        
    func config(with model: LayoutCouple) {
        self.model = model
        proportion = CGFloat(model.proportion)
        arrangement = model.arrangement
    }
    
    func configure(withFirst item: AtomPresenter) {
        self.firstItem = item
        item.view.frame = firstContainerView.bounds
        firstContainerView.addSubview(item.view)
    }
    
    func configure(withSecond item: AtomPresenter) {
        self.secondItem = item
        item.view.frame = secondContainerView.bounds
        secondContainerView.addSubview(item.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let newStartPoint = touch.location(in: self.view)
            if (controlView.frame.contains(newStartPoint)) {
                startPoint = newStartPoint
            } else {
                startPoint = nil
            }
            
            if firstContainerView.frame.contains(newStartPoint) {
                select(item: firstItem)
            } else if secondContainerView.frame.contains(newStartPoint) {
                select(item: secondItem)
            } else {
                select(item: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let sp = startPoint {
            let movedLocation = touch.location(in: self.view)
            let diff = (arrangement == .horizontal) ? (movedLocation.x - sp.x) : (movedLocation.y - sp.y)
            let proportionToSize = (arrangement == .horizontal) ? view.bounds.size.width : view.bounds.size.height
            let prop = diff / proportionToSize
            proportion = proportion + prop
            startPoint = movedLocation
        }
    }
        
    func updateControlDisplaying() {
        equalWidthConstraint?.isActive = false
        if let firstContainerView = firstContainerView {
            let attr: NSLayoutConstraint.Attribute = (arrangement == .horizontal) ? .width : .height
            let equalWC = NSLayoutConstraint(item: firstContainerView, attribute: attr, relatedBy: .equal, toItem: self.view, attribute: attr, multiplier: CGFloat(proportion), constant: 0)
            self.view.addConstraint(equalWC)
            equalWidthConstraint = equalWC
        }
    }
}
