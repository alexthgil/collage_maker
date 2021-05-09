//
//  ExportViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

protocol ExportViewControllerDelegate: class {
    func exportViewControllerWantsPerformExport()
}

class ExportViewController: UIViewController {

    @IBOutlet private weak var layoutContainer: UIView!
    private var layoutPresenter: SerialViewsLayoutPresenter?
    private var layoutIndex: Int = -1
    weak var delegate: ExportViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContainer.layer.borderWidth = 1.0
        layoutContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .done, target: self, action: #selector(self.exportButtonAction(sender:)))
    }
    
    @objc func exportButtonAction(sender: UIBarButtonItem) {
        delegate?.exportViewControllerWantsPerformExport()
    }
    
    func configure(with layoutIndex: Int) {
        self.layoutIndex = layoutIndex
        if let layout = Storage.shared.layoutManager.layout(at: layoutIndex) {
            let lP = SerialViewsLayoutPresenter()
            lP.configure(with: layout)
            lP.vc.view.frame = layoutContainer.bounds
            layoutContainer.addSubview(lP.vc.view)
            layoutPresenter = lP
        }
    }
    
    let serialImagesRequestPerformer = SerialImagesRequestPerformer()

    override func viewWillAppear(_ animated: Bool) {
        if let layout = Storage.shared.layoutManager.layout(at: layoutIndex) {
            let items = layout.collectItems()
            serialImagesRequestPerformer.requestImages(for: items) {[weak self] in
                DispatchQueue.main.async {[weak self] in
                    guard let s = self else {
                        return
                    }
                    
                    s.configure(with: s.layoutIndex)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let layout = Storage.shared.layoutManager.layout(at: layoutIndex) {
            let items = layout.collectItems()
            for item in items {
                item.setOriginalImage(nil)
            }
        }
    }
}
