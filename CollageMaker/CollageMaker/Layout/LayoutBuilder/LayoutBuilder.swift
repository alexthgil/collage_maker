//
//  LayoutBuilder.swift
//  CollageMaker
//
//  Created by Alex on 12/5/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

enum LayoutItem: Equatable {
    static func == (lhs: LayoutItem, rhs: LayoutItem) -> Bool {
        switch (lhs, rhs) {
        case (.couple(let a), .couple(let b)):
            return a === b
        case (.picture(let a), .picture(let b)):
            return a === b
        default:
            return false
        }
    }
    
    case picture(PictureViewItem)
    case couple(LayoutCouple)
}

class LayoutBuilder {
    
    func build(from picturesBatch: [PhotoItem]) -> [LayoutCouple] {
        var l = [LayoutCouple]()
        let count = picturesBatch.count
        if count == 2 {
            l.append(build1x1(pictures: picturesBatch, axis: .horizontal))
            l.append(build1x1(pictures: picturesBatch, axis: .vertical))
        } else if count == 3 {
            l.append(build1x2(pictures: picturesBatch,axis: .horizontal))
            l.append(build1x2(pictures: picturesBatch, axis: .vertical))
        } else if count == 4 {
            l.append(build2x2(pictures: picturesBatch, axis: .horizontal))
            l.append(build2x2(pictures: picturesBatch, axis: .vertical))
            l.append(build1x3(pictures: picturesBatch, axis: .horizontal))
            l.append(build1x3(pictures: picturesBatch, axis: .vertical))
        } else if count > 4 {
            for _ in 0..<count {
                let layout = LayoutCouple(first: .picture(PictureViewItemMock()), second: .picture(PictureViewItemMock()))
                l.append(layout)
            }
            return l
        } else {
            return l
        }
        return l
    }
    
    private func build1x1(pictures: [PhotoItem], axis: Arrangement) -> LayoutCouple {
        
        let aSize = pictures[0].previewImage?.size ?? .init(width: 1, height: 1)
        let bSize = pictures[1].previewImage?.size ?? .init(width: 1, height: 1)
        let koef = aSize.height / bSize.height
        let newBW = bSize.width * koef
        let w = newBW + aSize.width
        let h = max(aSize.height, bSize.height)
        
        let a = PictureViewItemMock()
        a.photoItem = pictures[0]
        let b = PictureViewItemMock()
        b.photoItem = pictures[1]
        let l = LayoutCouple(first: .picture(a), second: .picture(b))
        l.arrangement = axis
        l.preferedSize = CGSize(width: w, height: h)
        return l
    }
    
    private func build1x2(pictures: [PhotoItem], axis: Arrangement) -> LayoutCouple {
        
        let a = PictureViewItemMock()
        a.photoItem = pictures[0]
    
        let ba  = PictureViewItemMock()
        ba.photoItem = pictures[1]
        
        let bb = PictureViewItemMock()
        bb.photoItem = pictures[2]
        
        let b = LayoutCouple(first: .picture(ba), second: .picture(bb))
        b.proportion = 0.5
        b.arrangement = axis
        let c = LayoutCouple(first: .picture(a), second: .couple(b))
        c.proportion = 1.0 / 3.0
        c.arrangement = axis
        return c
    }
    
    private func build2x2(pictures: [PhotoItem], axis: Arrangement) -> LayoutCouple {
        
        let aa  = PictureViewItemMock()
        aa.photoItem = pictures[0]
        
        let ab = PictureViewItemMock()
        ab.photoItem = pictures[1]
    
        let ba  = PictureViewItemMock()
        ba.photoItem = pictures[2]
        
        let bb = PictureViewItemMock()
        bb.photoItem = pictures[3]
        
        let a = LayoutCouple(first: .picture(aa), second: .picture(ab))
        a.arrangement = axis
        let b = LayoutCouple(first: .picture(ba), second: .picture(bb))
        b.arrangement = axis
        
        return LayoutCouple(first: .couple(a), second: .couple(b))
    }
    
    private func build1x3(pictures: [PhotoItem], axis: Arrangement) -> LayoutCouple {
        
        let aa  = PictureViewItemMock()
        aa.photoItem = pictures[0]
        
        let bb = PictureViewItemMock()
        bb.photoItem = pictures[1]
    
        let cc  = PictureViewItemMock()
        cc.photoItem = pictures[2]
        
        let ff = PictureViewItemMock()
        ff.photoItem = pictures[3]
        
        let a = LayoutCouple(first: .picture(aa), second: .picture(bb))
        a.arrangement = axis
        a.proportion = 1.0 / 3.0
        let b = LayoutCouple(first: .couple(a), second: .picture(cc))
        b.arrangement = axis
        b.proportion = 2.0 / 3.0
        
        return LayoutCouple(first: .picture(ff), second: .couple(b))
    }
}
