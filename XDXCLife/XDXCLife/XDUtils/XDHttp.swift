//
//  XDHttp.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import Foundation
import Moya
import Alamofire
import HandyJSON


/// 网络请求成功
typealias loadDataSuccessCompletion = (_ target: TargetType, _ result: Any?) -> Void
/// 网络请求失败
typealias loadDataFailCompletion    = (_ target: TargetType, _ code: XDHttp.LoadDataResponseCode, _ errorMsg: String?) -> Void

struct XDHttp {
    private init() {}
    
    /// 记录用户登录失效弹窗
    static var isAlertUserLoginExpire = false
    
    /// 网络状态
    private static var networkManager = NetworkReachabilityManager()
    
    /// 网络是否可用
    static var isReachable: Bool {
        return networkManager?.isReachable ?? false
    }
    
    /// App 服务器地址
    static var rootUrl: String {
        return "http://test.huijitangzhibo.com"
    }
    
    static var deviceType: String {
        return "iphone"
    }
    
    static var webZhifuUrl: String {
        return "\(rootUrl)/pay/index"
    }
    
    /// 文件URL前缀
    static let fileRootURL  = "https://doujiao-1303149332.cos.ap-shenzhen-fsi.myqcloud.com/"
    /// Socket
    static let socketURL    = "ws://47.112.249.163:9501"
    
    /// 请求每一页的数据个数
    static let limit = 20
    /// 翻页请求参数
    static let paramsPageKey = "page"
    /// 服务器返回格式 code 字段
    static let responeDataKeyCode = "status"
    /// 服务器返回格式 info 字段
    static let responeDataKeyMsg = "msg"
    /// 服务器返回格式 data 字段
    static let responeDataKeyData = "data"
    /// 服务器返回格式 列表数据 字段
    static let responeDataKeyList = "data"
    /// 服务器返回状态响应 这是个bool值
    static let responeDataKeySuccess = "success"
    /// 接口请求地址
    static var baseServiceURL: URL {
        return URL(string: rootUrl)!
    }
    
    static var baseHeaders: [String : String]? {
//        let token = YQUserManager.shared.user?.token ?? ""
        
        let dic = [
            "XX-Device-Type": deviceType,
            "XX-Api-Version": XDAppConfig.appVersion,
//            "token": token,
        ]
        
        return dic
    }
    
    /// 默认请求参数
    static func baseParameters() -> [String : Any]? {
        return nil
    }
}

// MARK: - 监听网络状态
extension XDHttp {
    static func listenerNetwork() {
        networkManager?.startListening(onQueue: DispatchQueue(label: "com.Alamofire.networkState"), onUpdatePerforming: { (status) in
            switch status {
            case .unknown:
                XDNotifiCenter.post(name: .networkDisconnect, object: nil)
            case .notReachable:
                XDNotifiCenter.post(name: .networkDisconnect, object: nil)
            case .reachable(_):
                XDNotifiCenter.post(name: .networkConnect, object: nil)
            }
        })
    }
}

extension XDHttp {
    
    enum LoadDataResponseCode: Int {
        /// APP版本更新
        case appVersionLow  = -1
        /// 空数据
        case noData         = -2
        /// 没有更多数据
        case noMoreData     = -3
        /// 无网络
        case noNetwork      = -4
        /// 数据解析错误
        case dataError      = -5
        /// 参数错误
        case paramError     = -6
        /// 请求成功
        case success        = 200
        /// 服务器错误
        case noService      = 403
        /// 未登录
        case noLogin        = 401
        
        /// 返回对应的空视图状态
        var emptyDataType: XDEmptyDataView.EmptyDataType? {
            switch self {
            case .noNetwork:    return .noNetwork
            case .noService:    return .noService
            case .noData:       return .noData
            case .noLogin:      return .noLogin
            default:            return nil
            }
        }
    }
}

protocol XDServiceProtocol {
    /// 请求参数
    var parameters: [String:Any]? { get }
    /// 请求参数编码
    var parameterEncoding: ParameterEncoding { get }
}

extension XDServiceProtocol {
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
}

extension TargetType {
    /// 请求地址
    var baseURL: URL {
        return XDHttp.baseServiceURL
    }
    /// 请求头
    var headers: [String : String]? {
        return XDHttp.baseHeaders
    }
    /// 请求方式
    var method: Moya.Method {
        return .post
    }
    /// 这个就是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}

// MARK: - MoyaProvider loadData
extension MoyaProvider {
    
    
    /// 网络请求基础方法
    /// - Parameters:
    ///   - target: Target
    ///   - page: 页数，需要翻页时传（会自动解析data，不传可以自己解析）
    ///   - showLoadHUD: 加载框
    ///   - loadUserInteraction: 加载的时候是否可以响应其他事件
    ///   - showSuccessHUD: 成功提示
    ///   - showErrorHUD: 错误提示
    ///   - resultUserInteraction: 加载成功的时候是否可以响应其他事件
    ///   - isLog: 是否输出日志
    ///   - successCompletion: 请求成功回调
    ///   - errorCompletion: 请求失败回调
    /// - Returns: <#description#>
    @discardableResult
    func loadData(_ target: Target,
                  page: Int = 0,
                  showLoadHUD: Bool = true,
                  loadUserInteraction: Bool = true,
                  showSuccessHUD: Bool = false,
                  showErrorHUD: Bool = true,
                  resultUserInteraction: Bool = true,
                  isLog: Bool = true,
                  successCompletion: loadDataSuccessCompletion? = nil,
                  errorCompletion: loadDataFailCompletion? = nil
                  ) -> Cancellable {
        
        var apiKey = "\(target.baseURL.absoluteString)\(target.path)"
        
        if isLog {
            XDLog("请求参数：\(apiKey)")
        }
        
        let RESULT_CODE = XDHttp.responeDataKeyCode
        let RESULT_MSG  = XDHttp.responeDataKeyMsg
        let RESULT_DATA = XDHttp.responeDataKeyData
        
        func handleResult(json: [String:Any]) {
            if let result_code = json[RESULT_CODE] as? Int,
               let resulCode = XDHttp.LoadDataResponseCode(rawValue: result_code),
               let result_info = json[RESULT_MSG] as? String {
                
                if isLog {
                    XDLog(json)
                }
                
                if resulCode == .success {
                    if showLoadHUD {
                        XDHUD.toast(result_info, isUserInteraction: resultUserInteraction)
                    } else {
                        if showLoadHUD {
                            XDHUD.closeHUD()
                        }
                    }
                    
                    var data = json[RESULT_DATA]
                    
                    // 传了页数，便为list数据，自动提取list数据
                    if page > 0, let dic = data as? [String : Any], let listData = dic[XDHttp.responeDataKeyList] as? [[String : Any]] {
                        data = listData
                    }
                    
                    if let data = data as? [String : Any] {// 对象
                        successCompletion?(target, data)
                    } else if let data = data as? [[String:Any]] {//对象数组
                        // MARKL: - 处理空数据
                        if (page == 0 || page == 1) && data.isEmpty {
                            errorCompletion?(target, .noData, result_info)
                        } else {
                            if data.count < 10 {
                                errorCompletion?(target, .noMoreData, result_info)
                            }
                            
                            successCompletion?(target, data)
                        }
                    } else {
                        successCompletion?(target, data)//其他数据
                    }
                } else {
                    if resulCode == .noLogin {
                        if XDHttp.isAlertUserLoginExpire {
                            return
                        }
                        
                        XDHttp.isAlertUserLoginExpire = true
                        // 去登陆
                        
                    } else if resulCode == .appVersionLow {
                        // 版本过低去更新
                        
                    } else {
                        if showErrorHUD {
                            XDHUD.toast(result_info, isUserInteraction: resultUserInteraction)
                        } else {
                            if showErrorHUD {
                                XDHUD.closeHUD()
                            }
                        }
                    }
                    
                    errorCompletion?(target, resulCode, result_info)
                }
            }
        }
        
        if showLoadHUD {
            XDHUD.loading(isUserInteraction: loadUserInteraction)
        }
        
        if isLog {
            XDLog("接口地址：" + target.baseURL.absoluteString + target.path)
        }
        
        return request(target, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let fresponse = try response.filterSuccessfulStatusCodes()
                    if let josn = try fresponse.mapJSON() as? [String:Any] {
                        handleResult(json: josn)
                    } else {
                        errorCompletion?(target, .dataError, "数据无法解析")
                    }
                    
                } catch {
                    if showErrorHUD {
                        XDHUD.toast("服务器出错了", isUserInteraction: resultUserInteraction)
                    } else {
                        if showLoadHUD {
                            XDHUD.closeHUD()
                        }
                    }
                    
                    errorCompletion?(target, .noService, "服务器出错了")
                }
                break
            case let .failure(error):
                if showErrorHUD {
                    if error.localizedDescription.contains("已取消") {
                        XDHUD.closeHUD()
                    } else if error.localizedDescription.contains("断开与互联网的连接") {
                        XDHUD.toast("请检查网络是否连接", isUserInteraction: resultUserInteraction)
                    } else {
                        if showLoadHUD {
                            XDHUD.closeHUD()
                        }
                    }
                    
                    XDNotifiCenter.post(name: .networkError, object: nil)
                    errorCompletion?(target, .noNetwork, "网络错误")
                }
            }
        })
    }
    
    /// 请求model数据
    /// - Parameters:
    ///   - mirroModel: 要转的model
    ///   - mirroKey: model对应在data字段中的key
    ///   - target: Target
    ///   - page: 页数，需要翻页时传
    ///   - showLoadHUD: 加载框
    ///   - loadUserInteraction: 加载的时候是否可以响应其他事件
    ///   - showSuccessHUD: 成功提示
    ///   - showErrorHUD: 失败提示
    ///   - resultUserInteraction: 加载成功的时候是否可以响应其他事件
    ///   - isLog: 是否输出日志
    ///   - succeccCompletion: 请求成功回调
    ///   - errorCompletion: 请求失败回调
    /// - Returns: <#description#>
    @discardableResult
    func loadModel<M: HandyJSON>(_ mirroModel: M.Type,
                                 mirroKey: String = "",
                                 target: Target,
                                 page: Int = 0,
                                 showLoadHUD: Bool = true,
                                 loadUserInteraction: Bool = true,
                                 showSuccessHUD: Bool = false,
                                 showErrorHUD: Bool = true,
                                 resultUserInteraction: Bool = true,
                                 isLog: Bool = true,
                                 succeccCompletion: ((_ target: TargetType,_ result: M) -> Void)? = nil,
                                 errorCompletion: loadDataFailCompletion? = nil) -> Cancellable {
        
        return loadData(target, page: page, showLoadHUD: showLoadHUD, loadUserInteraction: loadUserInteraction, showSuccessHUD: showSuccessHUD, showErrorHUD: showErrorHUD, resultUserInteraction: resultUserInteraction, isLog: isLog, successCompletion: { (target, data) in
          
            if let data = data as? [String : Any] {
                if !mirroKey.isEmpty, let json = data[mirroKey] as? [String : Any] {
                    if let model = M.deserialize(from: json) {
                        succeccCompletion?(target, model)
                        return
                    }
                } else {
                    if let model = M.deserialize(from: data) {
                        succeccCompletion?(target, model)
                        return
                    }
                }
            }
            
        }, errorCompletion: errorCompletion)
    }
    
    /// 请求 数组model 数据
    /// - Parameters:
    ///   - mirroModel: 要转的Model
    ///   - mirroKey: model对应在data字段中的key
    ///   - target: Target
    ///   - page: 页数，需要翻页时传
    ///   - showLoadHUD: 加载框
    ///   - loadUserInteraction: 加载的时候是否可以响应其他事件
    ///   - showSuccessHUD: 成功提示
    ///   - showErrorHUD: 失败提示
    ///   - resultUserInteraction: 加载成功的时候是否可以响应其他事件
    ///   - isLog: 是否输出日志
    ///   - succeccCompletion: 请求成功回调
    ///   - errorCompletion: 请求失败回调
    /// - Returns: <#description#>
    func loadArrayModel<M: HandyJSON>(_ mirroModel: M.Type,
                                      mirroKey: String = XDHttp.responeDataKeyList,
                                      target: Target,
                                      page: Int = 0,
                                      showLoadHUD: Bool = true,
                                      loadUserInteraction: Bool = true,
                                      showSuccessHUD: Bool = false,
                                      showErrorHUD: Bool = true,
                                      resultUserInteraction: Bool = true,
                                      isLog: Bool = true,
                                      succeccCompletion: ((_ target: TargetType,_ result: [M]) -> Void)? = nil,
                                      errorCompletion: loadDataFailCompletion? = nil) -> Cancellable {
        
        return loadData(target, page: page, showLoadHUD: showLoadHUD, loadUserInteraction: loadUserInteraction, showSuccessHUD: showSuccessHUD, showErrorHUD: showErrorHUD, resultUserInteraction: resultUserInteraction, isLog: isLog, successCompletion: { (target, data) in
            
            if let data = data as? [[String : Any]] {
                let models = data.map({ M.deserialize(from: $0)! })
                
                if models.isEmpty {
                    errorCompletion?(target, .noData, "暂无数据")
                } else {
                    succeccCompletion?(target, models)
                }
            } else if let data = data as? [String : Any], !mirroKey.isEmpty, let json = data[mirroKey] as? [[String: Any]] {
                let models = json.map({ M.deserialize(from: $0)! })
                
                if models.isEmpty {
                    errorCompletion?(target, .noData, "暂无数据")
                } else {
                    succeccCompletion?(target, models)
                }
            } else {
                errorCompletion?(target, .noData, "数据无法解析")
            }
            
        }, errorCompletion: errorCompletion)
    }
}

extension String {
    /// 自动拼接完整的 http 链接
    var fullHttp: String {
        if hasPrefix("http") {
            return self
        }
        return "https://\(self)"
    }
    
    /// 自动拼接完整的URL 链接
    var fullURL: String {
        return hasPrefix("http") ? self : (XDHttp.rootUrl + self)
    }
    
    /// 自动拼接完整的文件 URL 链接
    var fullFileURL: String {
        return hasPrefix("http") ? self : (XDHttp.fileRootURL + self)
    }
}
