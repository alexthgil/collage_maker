//
//  ExportManager.swift
//  CollageMaker
//
//  Created by Alex on 12/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class ExportManager {
    
    private let canvas: ExportCanvas
    private let compoundPerformer: PictureCompoundPerformer
    
    init(canvasSize: CGSize) {
        canvas = ExportCanvas(size: canvasSize)
        compoundPerformer = PictureCompoundPerformer(canvas: canvas)
    }
        
    func exportImage(from layout: LayoutCouple, operationType: RenderOperationType) -> UIImage? {
        layout.draw(at: CGRect(origin: .zero, size: canvas.size), with: compoundPerformer, operationType: operationType)
        return compoundPerformer.buildImage()
    }
}
