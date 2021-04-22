//
//  XDEmptyDataView.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/20.
//

import UIKit

class XDEmptyDataView: UIView {
    private var _contentStackView: UIStackView!
    /// 标题
    private var _textContentStackView: UIStackView!
    /// 控件的垂直间距
    private var verticalSpace: CGFloat = 20
    /// 文本控件垂直间距
    private var textVerticalSpace: CGFloat = 10
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel?
    private var antionButton: UIButton?
    
    /// 设置Y偏移，负数往上移。正数往下移
    var contentOffsetY: CGFloat = -50 {
        didSet {
            _contentStackView?.snp.updateConstraints {
                $0.centerY.equalTo(self).offset(contentOffsetY)
            }
        }
    }
    
    private(set) var type: EmptyDataType = .noNetwork//默认网络错误
    var actionCallback: ((_ type: EmptyDataType) -> Void)?
    
    
    init(frame: CGRect, type: EmptyDataType) {
        super.init(frame: frame)
        
        self.type = type
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let button = newSuperview?.subviews.filter({ $0 is UIButton }).first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                newSuperview?.sendSubviewToBack(button)
            }
        }
    }
}

// MARK: - event, reponse
extension XDEmptyDataView {
    @objc private func actionBtnTap(_ sender: UIButton) {
        actionCallback?(type)
    }
}

// MARK: - setter, getter
extension XDEmptyDataView {
    @objc dynamic func setupUI() {
        // 外层容器
        _contentStackView = UIStackView()
        _contentStackView.axis = .vertical
        _contentStackView.alignment = .center
        _contentStackView.distribution = .fill
        _contentStackView.spacing = verticalSpace
        self.addSubview(_contentStackView)
        _contentStackView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self).offset(contentOffsetY)
            $0.width.lessThanOrEqualTo(bounds.width - 20)
            $0.height.lessThanOrEqualTo(bounds.height - 20)
        }
        
        // 图片
        imageView = UIImageView()
        imageView?.image = type.image
        _contentStackView.addArrangedSubview(imageView!)
        
        // 文本容器
        _textContentStackView = UIStackView()
        _textContentStackView.axis = .vertical
        _textContentStackView.alignment = .fill
        _textContentStackView.distribution = .fill
        _textContentStackView.spacing = textVerticalSpace
        _contentStackView.addArrangedSubview(_textContentStackView)
        
        // 标题
        titleLabel = UILabel()
        titleLabel.text = type.title
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = UIColor.color0xCCCCCC
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        _textContentStackView.addArrangedSubview(titleLabel)
        
        if let subTitle = type.subTitle {
            subTitleLabel = UILabel()
            subTitleLabel?.text = subTitle
            subTitleLabel?.numberOfLines = 0
            subTitleLabel?.lineBreakMode = .byWordWrapping
            subTitleLabel?.textColor = UIColor.color0xCCCCCC
            subTitleLabel?.font = UIFont.systemFont(ofSize: 12)
            subTitleLabel?.textAlignment = .center
            _textContentStackView.addArrangedSubview(subTitleLabel!)
        }
        
        // 按钮
        if let btnTitle = type.btnTitle {
            antionButton = UIButton(type: .custom)
            antionButton?.setTitle(btnTitle, for: .normal)
            antionButton?.setTitleColor(UIColor.white, for: .normal)
            antionButton?.backgroundColor = UIColor.themeYellow
            antionButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            antionButton?.cornerRadius = 18
            antionButton?.addTarget(self, action: #selector(actionBtnTap(_:)), for: .touchUpInside)
            _contentStackView.addArrangedSubview(antionButton!)
            
            antionButton?.snp.makeConstraints {
                $0.width.equalTo(158)
                $0.height.equalTo(36)
            }
        }
    }
}

extension XDEmptyDataView {
    enum EmptyDataType: Equatable {
        /// 无网络
        case noNetwork
        /// 无数据
        case noData
        /// 服务器错误
        case noService
        /// 未登录
        case noLogin
        /// 请求失败
        case requestFail(errorTip: String)
        /// 没有定位权限
        case noLocationAuth
        
        var image: UIImage? {
            switch self {
            case .noNetwork:        return UIImage(named: "noData")
            case .noData:           return UIImage(named: "noData")
            case .noService:        return UIImage(named: "noData")
            case .noLogin:          return UIImage(named: "noData")
            case .requestFail(_):   return UIImage(named: "noData")
            case .noLocationAuth:   return UIImage(named: "noData")
            }
        }
        
        var title: String {
            switch self {
            case .noNetwork:                    return "网络异常"
            case .noData:                       return "暂无任何内容哦~"
            case .noService:                    return "服务器出错"
            case .noLogin:                      return "请先登录"
            case .requestFail(let errorTip):    return errorTip
            case .noLocationAuth:               return "您未开启定位权限"
            }
        }
        
        var subTitle: String? {
            switch self {
            case .noLocationAuth:   return "建议打开定位权限查看附近动态"
            default:                return nil
            }
        }
        
        var btnTitle: String? {
            switch self {
            case .noNetwork:        return "重试"
            case .noLogin:          return "登录/注册"
            case .noLocationAuth:   return "打开定位权限"
            default:                return nil
            }
        }
        
        static func == (lhs: EmptyDataType, rhs: EmptyDataType) -> Bool {
            switch (lhs, rhs) {
            case (.noNetwork, .noNetwork),
                 (.noData, .noData),
                 (.noService, .noService),
                 (.noLogin, .noLogin),
                 (.noLocationAuth, .noLocationAuth):
                return true
            case (.requestFail(let lhsString), .requestFail(let rhsString)):
                return lhsString == rhsString
            default:
                return false
            }
        }
    }
}
