import UIKit
import Foundation

// MARK: - nav
public extension UIViewController {
    /// 显示导航栏
    /// - Parameter animated: <#animated description#>
    func showNavbar(animated: Bool = true) {
        wx_navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /// 隐藏导航栏
    /// - Parameter animated: <#animated description#>
    func hiddenNavbar(animated: Bool = true) {
        wx_navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - snp
import SnapKit
public extension UIViewController {
    var safeAreaTop: ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.top
        } else {
            return topLayoutGuide.snp.bottom
        }
    }
    
    var safeAreaBottom: ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.bottom
        } else {
            return bottomLayoutGuide.snp.top
        }
    }
}

// MARK: -
public extension UIViewController {
    /// 添加到父视图控制器上
    func displayContentController(_ childVC: UIViewController, superView: UIView? = nil) {
        addChild(childVC)
        if let superView = superView {
            childVC.view.frame = superView.bounds
            superView.addSubview(childVC.view)
        } else {
            childVC.view.frame = view.bounds
            view.addSubview(childVC.view)
        }
        childVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
    }
    
    /// 从父视图控制器上删除
    func removeFromSupervViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    /// 视图控制器切换
    func transition(from oldVC: UIViewController, to newVC: UIViewController) {
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        
        transition(from: oldVC, to: newVC, duration: 0, options: [], animations: {
            
        }) { finished in
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)
        }
    }
}

public extension UIViewController {
    // present 有 alertVC 先退 alertVC 在 present
    func presentIgnoreAbove(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil {
            presentedViewController?.dismiss(animated: false, completion: nil)
        }
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    // 界面上有 alertVC 导致 失效
    func dismissIgnoreAbove(animated: Bool) {
        if presentedViewController != nil {
            presentedViewController?.dismiss(animated: false, completion: nil)
        }
        dismiss(animated: animated, completion: nil)
    }
    
    // 返回根视图
    func dismissRootVC(animated: Bool) {
        var rootVC: UIViewController? = self
        
        while rootVC != nil {
            if let presentingViewController = rootVC?.presentingViewController?.presentingViewController {
                rootVC?.dismissIgnoreAbove(animated: false)
                rootVC = presentingViewController
            } else {
                rootVC?.dismissIgnoreAbove(animated: animated)
                rootVC = nil
            }
        }
    }
}
