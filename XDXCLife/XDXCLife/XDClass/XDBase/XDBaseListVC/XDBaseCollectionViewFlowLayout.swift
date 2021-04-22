//
//  XDBaseCollectionViewFlowLayout.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit

class XDBaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        estimatedItemSize = .zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // 只有一个 Cell 的时候，改变 Cell 的 X 坐标
        if let itemAttributes = attributes?.filter({ $0.representedElementKind == nil }), itemAttributes.count == 1 {
            if let currentAttribute = attributes?.first {
                currentAttribute.frame = CGRect(x: sectionInset.left,
                                                y: currentAttribute.frame.origin.y,
                                                width: currentAttribute.frame.size.width,
                                                height: currentAttribute.frame.size.height)
            }
        }
        
        return attributes
    }
}
