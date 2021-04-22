//
//  XDMineVC.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/21.
//
/**
 *  @author oy
 *
 *  @classBrief 我的
 *
 */


import UIKit

class XDMineVC: XDBaseTableViewVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        navbarTitle = "我的"
        
        tableViewStyle = .grouped
        tableViewFrame = self.view.bounds
        _listView.register(cellWithClass: UITableViewCell.self)
//        dataArray = [Section(cellArray: [Cell(data: UITableViewCell.reuseIdentifier),
//                                         Cell(data: UITableViewCell.reuseIdentifier),
//                                         Cell(data: UITableViewCell.reuseIdentifier)])]
    }

}

extension XDMineVC {
    override func cellForRow(_ listView: UITableView, at indexPath: IndexPath, data: Any?) -> UITableViewCell {
        let cell: UITableViewCell = listView.dequeueReusableCell(indexPath)
        cell.textLabel?.text = "第\(indexPath.row)"
        return cell
    }
}
