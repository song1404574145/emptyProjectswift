//
//  XDWaterFallLayout.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/21.
//

import UIKit

protocol XDWaterFallLayoutDeleget: class {
    func waterFallLayout(waterFlowLayout: XDWaterFallLayout, heightForRowAt indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
}

class XDWaterFallLayout: XDBaseCollectionViewFlowLayout {
    weak var delegate: XDWaterFallLayoutDeleget?
    var colunmCount = 2
    var columnMargin: CGFloat = 8
    var rowMargin: CGFloat  = 8
    var edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var attrsArr: [UICollectionViewLayoutAttributes] = []
    var columnHeights: [CGFloat] = []
    var contentHeight: CGFloat = 0
    
    
    override func prepare() {
        super.prepare()
        
        contentHeight = 0
        
        columnHeights = []
        
        (0..<colunmCount).forEach({ _ in columnHeights.append(edgeInsets.top) })
        
        attrsArr = []
        
        guard let count = self.collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            if let attrs = self.layoutAttributesForItem(at: indexPath) {
                attrsArr.append(attrs)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if let collectionViewW = self.collectionView?.frame.size.width {
            let cellW = (collectionViewW - edgeInsets.left - edgeInsets.right - CGFloat(colunmCount - 1) * columnMargin) / CGFloat(colunmCount)
            
            if let cellH = delegate?.waterFallLayout(waterFlowLayout: self, heightForRowAt: indexPath, itemWidth: cellW) {
                var destColumn = 0
                var minColumnHeight = columnHeights[0]
                
                for i in 0..<colunmCount {
                    let columnHeight = columnHeights[i]
                    
                    if minColumnHeight > columnHeight {
                        minColumnHeight = columnHeight
                        destColumn = i
                    }
                }
                
                let cellX = edgeInsets.left + CGFloat(destColumn) * (cellW + columnMargin)
                var cellY = minColumnHeight
                
                if cellY != edgeInsets.top {
                    cellY = cellY + self.rowMargin
                }
                
                attrs.frame = CGRect(x: cellX, y: CGFloat(cellY), width: cellW, height: cellH)
                
                columnHeights[destColumn] = attrs.frame.maxY
                
                let maxColumnHeight = columnHeights[destColumn]
                
                if contentHeight < maxColumnHeight {
                    contentHeight = maxColumnHeight
                }
            }
        }
        
        return attrs
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArr
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: contentHeight + edgeInsets.bottom)
    }
}
