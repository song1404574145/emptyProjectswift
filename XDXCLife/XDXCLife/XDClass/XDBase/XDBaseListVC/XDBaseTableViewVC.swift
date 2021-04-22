//
//  XDBaseTableViewVC.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit

class XDBaseTableViewVC: XDBaseVC {
    
    private(set) var _listView: UITableView! {
        didSet {
            _listView.delegate = self
            _listView.dataSource = self
            _listView.separatorStyle = .none
            _listView.estimatedRowHeight = 166
            _listView.keyboardDismissMode = .onDrag
            _listView.showsVerticalScrollIndicator = false
            _listView.showsHorizontalScrollIndicator = false
            _listView.register(XDEmptyDataCell.classForCoder(), forCellReuseIdentifier: XDEmptyDataCell.reuseIdentifier)
            if _listView.tableFooterView == nil {
                /// 默认 FooterView
                _listView.tableFooterView = UIView()
            }
        }
    }
    
//    private(set) lazy var _listView: UITableView! = {
//        let listView = UITableView.init(frame: .zero, style: .plain)
//        listView.delegate = self
//        listView.dataSource = self
//        listView.separatorStyle = .none
//        listView.estimatedRowHeight = 166
//        listView.keyboardDismissMode = .onDrag
//        listView.showsVerticalScrollIndicator = false
//        listView.showsHorizontalScrollIndicator = false
//        listView.register(XDEmptyDataCell.classForCoder(), forCellReuseIdentifier: XDEmptyDataCell.reuseIdentifier)
//        if listView.tableFooterView == nil {
//            /// 默认 FooterView
//            listView.tableFooterView = UIView()
//        }
//        return listView
//    }()
    
    override var emptyDataType: XDEmptyDataView.EmptyDataType! {
        didSet {
            hiddenLoadMore()
            dataArray = []
            reloadData()
        }
    }
    
    /// 是否无更多数据（有分页数据的列表，拿到数据后，就要设置改属性）
    var isNoMoreData = false {
        didSet {
            _listView.mj_footer?.isHidden = false
            
            if isNoMoreData {
                _listView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                endLoadMore()
            }
        }
    }
    
    /// 设置tableViewstyle，顺便重新初始化一下tableview
    var tableViewStyle: UITableView.Style? = .plain {
        didSet {
            if let style = tableViewStyle {
                _listView = UITableView.init(frame: .zero, style: style)
            } else {
                _listView = UITableView.init(frame: .zero, style: .plain)
            }
            self.view.addSubview(_listView)
        }
    }
    
    /// 设置tableview的frame，也可以在继承的类中用snipkit或者其他
    var tableViewFrame: CGRect? = .zero {
        didSet {
            if let frame = tableViewFrame {
                _listView.frame = frame
                reloadData()
            }
        }
    }
    
    /// page
    private(set) var page = 1
    /// 原数据源
    var originalDataArray: Any?
    /// 数据源
    var dataArray: [Section] = []
    
    var isNeedRefresh = true {
        didSet {
            if isNeedRefresh && (navigationController?.topViewController == self || navigationController?.topViewController == self.parent) {
                beginRefreshing()
            }
        }
    }
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _listView = UITableView.init(frame: .zero, style: .plain)
        
        if #available(iOS 11.0, *) {
            _listView.contentInsetAdjustmentBehavior = .never
            _listView.estimatedSectionHeaderHeight = 0
            _listView.estimatedSectionFooterHeight = 0
        } else {
            automaticallyAdjustsScrollViewInsets = false
            _listView.estimatedSectionHeaderHeight = 30
            _listView.estimatedSectionFooterHeight = 30
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNeedRefresh && _listView.mj_header?.isRefreshing == false {
            isNeedRefresh = false
            beginRefreshing()
        }
    }
    
    override func loadDataFail(_ target: TargetType, _ code: XDHttp.LoadDataResponseCode, _ errorMsg: String?) {
        endRefreshing()
        
        if code == .noMoreData {
            isNoMoreData = true
        } else {
            super.loadDataFail(target, code, errorMsg)
        }
    }
    
    override func loadDataSuccess(page: Int = 1, loadCount: Int = 0, maxLoadCount: Int = 0, isNoMoreData: Bool? = nil) {
        self.page = page
        
        endRefreshing()
        reloadData()
        removeEmptyDataType()
        
        if let isNoMoreData = isNoMoreData {
            self.isNoMoreData = isNoMoreData
        } else if loadCount > 0 && maxLoadCount > 0 {
            self.isNoMoreData = loadCount >= maxLoadCount
        } else if self.isNoMoreData == false {
            self.isNoMoreData = false
        }
    }
    
    func setNoMoreData(isNoMoreData: Bool) {
        endRefreshing()
        removeEmptyDataType()
        self.isNoMoreData = isNoMoreData
    }
    
    deinit {
        _listView.delegate = nil
        _listView.dataSource = nil
        _listView = nil
    }
}

// MARK: - 数据
extension XDBaseTableViewVC {
    
    /// 加载列表数据
    /// - Parameters:
    ///   - page: 加载页数（加载到数据的时候，记得调用loadDataSuccess(有分页要传page) 或者 reloadData）
    ///   - isShowLoadHUD: <#isShowLoadHUD description#>
    @objc dynamic func loadListData(page: Int = 1, isShowLoadHUD: Bool = true) {
        
    }
    
    /// 加载数据总数量
    /// - Parameters:
    ///   - filterSection: section 筛选条件
    ///   - filterCell: cell 筛选条件
    /// - Returns: <#description#>
    func loadDataCount(filterSection: ((Section) -> Bool)? = nil, filterCell: ((Cell) -> Bool)? = nil) -> Int {
        var data = dataArray

        if let filterSection = filterSection {
            data = data.filter(filterSection)
        }

        if let filterCell = filterCell {
            return data.map({ $0.cellArray.filter(filterCell).count }).reduce(0, { $0 + $1 })
        }

        return data.map({ $0.cellArray.count }).reduce(0, { $0 + $1 })
    }
    
    /// 刷新数据
    func reloadData() {
        UIView.performWithoutAnimation {
            self._listView?.reloadData()
        }
    }
    
    /// 提供cell
    /// - Parameters:
    ///   - listView: tableVIew
    ///   - indexPath: 序号
    ///   - data: 单个model
    /// - Returns: cell
    @objc dynamic func cellForRow(_ listView: UITableView, at indexPath: IndexPath, data: Any?) -> UITableViewCell {
        return UITableViewCell()
    }
    
    /// cell 点击事件
    /// - Parameters:
    ///   - listView: tableVIew
    ///   - indexPath: 序号
    ///   - data: 单个model
    /// - Returns: 是否执行 deselectRow
    @objc dynamic func didSelectRow(_ listView: UITableView, at indexPath: IndexPath, data: Any?) -> Bool {
        return true
    }
}

// MARK: - 协议方法
extension XDBaseTableViewVC: UITableViewDelegate, UITableViewDataSource {
    final func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[safe: section]?.cellArray.count ?? 0
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(tableView, at: indexPath, data: dataArray[safe: indexPath.section]?.cellArray[safe: indexPath.row]?.data)
    }
    
    /// 用 didSelectRow(indexPath: IndexPath, data: Any?)
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelectRow(tableView, at: indexPath, data: dataArray[safe: indexPath.section]?.cellArray[safe: indexPath.row]?.data) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArray[safe: indexPath.section]?.cellArray[safe: indexPath.row]?.height ?? 0.001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

// MARK: - Model
extension XDBaseTableViewVC {
    struct Section {
        var cellArray: [Cell] = []
    }
    
    struct Cell {
        var data: Any?
        var height: CGFloat = UITableView.automaticDimension
        
        init() {}
        
        init(data: Any?) {
            self.data = data
        }
        
        init(data: Any?, height: CGFloat) {
            self.data = data
            self.height = height
        }
    }
}

// MARK: - Refresh
extension XDBaseTableViewVC {
    
    /// 添加下拉刷新
    func addRefresh() {
        _listView.mj_header = XDDefaultRefreshHeader(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.isNoMoreData = false
            self.page = 1
            self.loadListData()
        })
    }
    /// 开启下拉刷新
    func beginRefreshing() {
        _listView?.mj_header?.beginRefreshing()
    }
    /// 结束下拉刷新
    func endRefreshing() {
        _listView?.mj_header?.endRefreshing()
    }
    func switchRefreshing(tint color: UIColor) {
        _listView?.mj_header?.tintColor = color
    }
    /// 添加上拉加载
    @objc dynamic func addLoadMore() {
        _listView?.mj_footer = XDDefaultRefreshFooter(refreshingBlock: { [weak self] in
            self?.loadListMoreData()
        })
        _listView?.mj_footer?.isHidden = true
    }
    /// 加载更多数据
    func loadListMoreData() {
        loadListData(page: page + 1)
    }
    /// 隐藏上拉加载
    func hiddenLoadMore() {
        _listView?.mj_footer?.isHidden = true
    }
    /// 结束下上拉加载
    func endLoadMore() {
        _listView?.mj_footer?.endRefreshing()
    }
    /// 设置page，一般不需要调用（设置默认页数时使用）
    func setPage(_ page: Int) {
        self.page = page
    }
}

// MARK: - EmptyDataType
extension XDBaseTableViewVC {
    override func setupEmptyDataType() {
        if let listView = _listView {
            
            listView.emptyDataSetDelegate = self
            listView.emptyDataSetSource = self
        }
//        _listView.emptyDataSetDelegate = self
//        _listView.emptyDataSetSource = self
        
    }
    override func showEmptyDataType() {
        endRefreshing()
        endLoadMore()
        _listView.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self._listView.removeEmptyDataSet()
            self._listView.reloadEmptyDataSet()
        }
    }
    
    override func removeEmptyDataType() {
        _listView.removeEmptyDataSet()
    }
    override func emptyDataSetViewFrame() -> CGRect {
        return _listView.bounds
    }
    override func tapEmptyDataType() {
        super.tapEmptyDataType()
        
        if emptyDataType == .noData {
            return
        }
        
        loadListData()
    }
}
