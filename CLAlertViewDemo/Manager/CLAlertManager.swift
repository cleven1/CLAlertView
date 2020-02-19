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
class CLAlertManager: NSObject {
    
    enum AlertPosition {
        case center
        case bottom
    }
    
    private static var vc:UIViewController?
    private static var containerView:UIButton?
    private static var contentView: UIView?
    private static var currentPosition: AlertPosition = .center
    
    public static func show(view: UIView, alertPostion: AlertPosition = .center, didCoverDismiss: Bool = false){
        contentView = view
        currentPosition = alertPostion
        containerView = UIButton(frame: CGRect(x: 0, y: 0, width: cl_screenWidht, height: cl_screenHeight))
        if didCoverDismiss {
            containerView?.addTarget(self, action: #selector(tapView), for: .touchUpInside)
        }
        containerView?.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.0)
        containerView?.addSubview(view)
        view.alpha = 0
        if alertPostion == .center {
            view.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }else{
            view.snp.makeConstraints { (make) in
                make.bottom.equalTo(containerView!.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
        }
        vc = UIViewController()
        vc?.view.backgroundColor = UIColor.clear
        vc?.view.addSubview(containerView!)
        vc?.modalPresentationStyle = .custom
        UIViewController.cl_topViewController()?.present(vc!, animated: false) {
            if alertPostion == .center {
                showCenterView(view: view)
            }else{
                showBottomView(view: view)
            }
        }
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private static func showCenterView(view: UIView){
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.7)
            view.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            }) { (_) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                        view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                    }) { (_) in
                        
                    }
                }
            }
        }
    }
    
    private static func showBottomView(view: UIView){
        view.alpha = 1.0
        view.frame.origin.y = cl_screenHeight
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.7)
            view.frame.origin.y = cl_screenHeight - view.bounds.height
        }) { (_) in
            
        }
    }
    
    public static func hiddenView(view: UIView = contentView ?? UIView()){
        NotificationCenter.default.removeObserver(self)
        UIView.animate(withDuration: 0.25, animations: {
            containerView?.backgroundColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 0.0)
            if currentPosition == .center {
                containerView?.alpha = 0.0
            }else{
                view.frame.origin.y = cl_screenHeight
            }
        }) { (_) in
            vc?.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc private static func tapView(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.1))) {
            self.hiddenView()
        }
    }
    
    private static var originFrame:CGRect = .zero
    // 键盘显示
    @objc private static func keyboardWillShow(notification: Notification) {
        originFrame = contentView!.frame
        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect)?.height
        let y = cl_screenHeight - (keyboardHeight ?? 304) - contentView!.frame.height - 20
        UIView.animate(withDuration: 0.25) {
            contentView?.frame.origin.y = y
        }
    }
    // 键盘隐藏
    @objc private static func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            contentView?.frame = originFrame
        }
    }
    
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
