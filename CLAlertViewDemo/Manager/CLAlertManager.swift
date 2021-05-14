//
//  DrugAlertManager.swift
//  DRUG
//
//  Created by cleven on 2020/2/4.
//  Copyright © 2020 Sheng. All rights reserved.
//

import UIKit

public let cl_screenWidht = UIScreen.main.bounds.width
public let cl_screenHeight = UIScreen.main.bounds.height
class GKAlertManager: NSObject {
    private struct GKAlertViewCache {
        var view: UIView?
        var index: Int = 0
    }
    enum AlertPosition {
        case center
        case bottom
    }
    
    private static var vc: UIViewController?
    private static var containerView: UIButton?
    private static var currentPosition: AlertPosition = .center
    private static var viewCache: [GKAlertViewCache] = []
    
    public static func show(view: UIView,
                            alertPostion: AlertPosition = .center,
                            didCoverDismiss: Bool = false){
        let index = viewCache.isEmpty ? 0 : viewCache.count
        viewCache.append(GKAlertViewCache(view: view, index: index))
        currentPosition = alertPostion
        if vc == nil {
            containerView = UIButton(frame: CGRect(x: 0, y: 0, width: cl_screenWidht, height: cl_screenHeight))
            containerView?.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.0)
        }
        if didCoverDismiss {
            containerView?.addTarget(self, action: #selector(tapView), for: .touchUpInside)
        }
        containerView?.addSubview(view)
        view.alpha = 0
        if alertPostion == .center {
            view.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }else{
            view.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
        }
        if vc == nil {
            vc = UIViewController()
            vc?.view.backgroundColor = UIColor.clear
            vc?.view.addSubview(containerView!)
            vc?.modalPresentationStyle = .custom
            UIViewController.cl_topViewController()?.present(vc!, animated: false) {
                showAlertPostion(alertPostion: alertPostion, view: view)
            }
        } else {
            showAlertPostion(alertPostion: alertPostion, view: view)
        }
    }

    private static func showAlertPostion(alertPostion: AlertPosition, view: UIView) {
        containerView?.layoutIfNeeded()
        if alertPostion == .center {
            showCenterView(view: view)
        }else{
            view.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(view.height)
            }
            containerView?.layoutIfNeeded()
            showBottomView(view: view)
        }
    }
    
    private static func showCenterView(view: UIView){
        if viewCache.isNotEmpty {
            viewCache.forEach({ $0.view?.alpha = 0 })
        }
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.backgroundColor = UIColor(red: 0.0/255,
                                                     green: 0.0/255,
                                                     blue: 0.0/255,
                                                     alpha: 0.5)
            view.alpha = 1.0
        })
    }
    
    private static func showBottomView(view: UIView){
        if viewCache.isNotEmpty {
            viewCache.forEach({ $0.view?.alpha = 0 })
        }
        view.alpha = 1.0
        view.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.backgroundColor = UIColor(red: 0.0/255,
                                                     green: 0.0/255,
                                                     blue: 0.0/255,
                                                     alpha: 0.5)
//            containerView?.layoutIfNeeded()
            containerView?.superview?.layoutIfNeeded()
        })
    }

    static func updateViewHeight() {
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.layoutIfNeeded()
        })
    }
    
    static func hiddenView(all: Bool = true, completion: (() -> Void)? = nil){
        if currentPosition == .bottom {
            guard let lastView = viewCache.last?.view else { return }
            lastView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(lastView.frame.height)
            }
        }
        UIView.animate(withDuration: 0.25, animations: {
            if all || viewCache.isEmpty {
                containerView?.backgroundColor = UIColor(red: 255.0/255,
                                                         green: 255.0/255,
                                                         blue: 255.0/255,
                                                         alpha: 0.0)
                containerView?.layoutIfNeeded()
            }
            if currentPosition == .center {
                viewCache.last?.view?.alpha = 0
            }
        }, completion: { (_) in
            if all || viewCache.isEmpty {
                vc?.dismiss(animated: false, completion: completion)
                vc = nil
            } else {
                viewCache.removeLast()
                viewCache.last?.view?.alpha = 1
            }
        })
    }
    
    @objc
    private static func tapView(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.1))) {
            self.hiddenView()
        }
    }
    
    private static var originFrame:CGRect = .zero
    // 键盘显示
//    @objc private static func keyboardWillShow(notification: Notification) {
//        originFrame = contentView!.frame
//        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect)?.height
//        let y = cl_screenHeight - (keyboardHeight ?? 304) - contentView!.frame.height - 20
//        UIView.animate(withDuration: 0.25) {
//            contentView?.frame.origin.y = y
//        }
//    }
//    // 键盘隐藏
//    @objc private static func keyboardWillHide(notification: Notification) {
//        UIView.animate(withDuration: 0.25) {
//            contentView?.frame = originFrame
//        }
//    }
    
}

extension UIViewController {
    
    static func cl_topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let window = UIApplication.shared.windows.first
        let viewController = viewController ?? window?.rootViewController
        
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty
        {
            return self.cl_topViewController(navigationController.viewControllers.last)
            
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController
        {
            return self.cl_topViewController(selectedController)
            
        } else if let presentedController = viewController?.presentedViewController {
            return self.cl_topViewController(presentedController)
            
        }
        
        return viewController
    }
}
