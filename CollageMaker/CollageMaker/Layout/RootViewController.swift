//
//  RootViewController.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, BasicConfigDelegate {
    
    @IBOutlet private weak var containerView: UIView!
    private let basicConfigViewController = BasicConfigViewController()
    private var exportPresenter: ExportPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicConfigViewController.delegate = self
        basicConfigViewController.view.frame = containerView.bounds
        containerView.addSubview(basicConfigViewController.view)
        DispatchQueue.main.async {
            self.basicConfigViewController.configure()
        }
    }
    
    //MARK: - BasicConfigDelegate
    
    func userDidSelectLayout(at index: Int) {
        let newExportPresenter = ExportPresenter()
        exportPresenter = newExportPresenter
        newExportPresenter.configure(with: index)
        self.navigationController?.pushViewController(newExportPresenter.vc, animated: true)
    }
}
