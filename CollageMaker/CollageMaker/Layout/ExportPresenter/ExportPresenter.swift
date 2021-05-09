//
//  ExportPresenter.swift
//  CollageMaker
//
//  Created by Alex on 12/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class ExportPresenter: AtomPresenter, ExportViewControllerDelegate {
    
    let vc: ExportViewController
    
    init() {
        vc = ExportViewController()
        vc.delegate = self
        _ = vc.view
    }
    
    var layoutIndex: Int = -1
    
    func configure(with layoutIndex: Int) {
        self.layoutIndex = layoutIndex
        vc.configure(with: layoutIndex)            
    }
    
    var exportProgressStateViewController: ExportProgressStateViewController?
    func exportViewControllerWantsPerformExport() {
        let ePStateViewController = ExportProgressStateViewController()
        exportProgressStateViewController = ePStateViewController
        ePStateViewController.modalPresentationStyle = .formSheet

        vc.navigationController?.present(ePStateViewController, animated: true, completion: {[weak self] in
            self?.performExport(completion: {
                DispatchQueue.main.async {[weak self] in
                    self?.exportProgressStateViewController?.dismiss(animated: true, completion:nil)
                    self?.exportProgressStateViewController = nil
                }
            })
        })
    }
    
    private func performExport(completion: @escaping (() -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let li = self?.layoutIndex, let layout = Storage.shared.layoutManager.layout(at: li) {
                let exportManager = ExportManager(canvasSize: CGSize(width: 2000, height: 2000))
                if let img = exportManager.exportImage(from: layout, operationType: .useLargeImage) {
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
    }
    
    //MARK: - ExportPresenter
    
    var view: UIView {
        return vc.view
    }
    
}
