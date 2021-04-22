//
//  XDEmptyDataCell.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit
import BFEmptyDataSet

class XDEmptyDataCell: UITableViewCell {
    private var cellHight: CGFloat = 280
    
    var emptyDataType: XDEmptyDataView.EmptyDataType = .noData {
        didSet {
            selectionStyle = .none
            
            contentView.removeSubviews()
            
            let _emptyDataView = XDEmptyDataView(frame: CGRect(origin: .zero, size: CGSize(width: contentView.width, height: cellHight)), type: emptyDataType)
            contentView.addSubview(_emptyDataView)
            _emptyDataView.actionCallback = { (type) in
                if type == .noLogin {
//                    YQUserManager.shared.pushLogin()
                }
            }
            _emptyDataView.contentOffsetY = 0
            _emptyDataView.snp.makeConstraints({
                $0.edges.equalToSuperview()
                $0.height.equalTo(cellHight)
            })
        }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: targetSize.height)
    }
}
