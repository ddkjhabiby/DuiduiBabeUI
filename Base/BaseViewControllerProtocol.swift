//
//  BaseViewControllerProtocol.swift
//  Bobo
//
//  Created by ddkj on 2019/9/3.
//  Copyright © 2019 duiud. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

let loadingCircleImages: [UIImage] = {
   var array = [UIImage]()
   for i in 0...25 {
       let imageName = "wc_loading_000" + String(format: "%02d", i)
       let image = UIImage.init(named: imageName)
       if image != nil {
           array.append(image!)
       }
   }
   return array
}()
//
fileprivate let loadingView = { () -> UIImageView in
    let view = UIImageView()
    view.animationImages = loadingCircleImages
    view.contentMode = .scaleAspectFit;
    view.animationDuration = 1
    view.animationRepeatCount = 0
    view.size = CGSize(width: 70.0, height: 70.0)
    return view
}()

fileprivate var task: GCDUtil.DispatchTask?

public protocol BaseViewControllerProtocol {
    
    func showLoadingActivity()
    
    func showLoadingActivity(duration: TimeInterval)
    
    func hideLoadingActivity()
    
    func showCenterActivity()
    
    func hideActivity()
    
    func showToast(_ toastStr: String)
    
    func showToast(_ toastStr: String, position: ToastPosition)
    
    func showToastOnWindow(_ toastStr: String)
    
    func hideAllToast()
    
    func showHUD()
    
    func hideHUD()
}

public extension BaseViewControllerProtocol where Self: UIViewController {
    
    func showLoadingActivity() {
        loadingView.center = CommonUIUtil.mainWindow.center
        CommonUIUtil.mainWindow.addSubview(loadingView)
        loadingView.startAnimating()
        CommonUIUtil.mainWindow.isUserInteractionEnabled = false
    }
    
    func showLoadingActivity(duration: TimeInterval) {
        loadingView.center = CommonUIUtil.mainWindow.center
        CommonUIUtil.mainWindow.addSubview(loadingView)
        loadingView.startAnimating()
        CommonUIUtil.mainWindow.isUserInteractionEnabled = false
        task = GCDUtil.dispatchDelay(duration) {
            self.hideLoadingActivity()
        }
    }
    
    func hideLoadingActivity() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
        CommonUIUtil.mainWindow.isUserInteractionEnabled = true
        GCDUtil.dispatchCancle(task)
    }
    
    func showCenterActivity() {
        view.makeToastActivity(.center)
    }
    
    func hideActivity() {
        view.hideToastActivity()
    }
    
    func showToast(_ toastStr: String) {
        guard toastStr.count > 0 else {
            return
        }
        #if DEBUG
        #else
        hideAllToast()
        #endif
        view.makeToast(toastStr)
    }
    
    func showToast(_ toastStr: String, position: ToastPosition) {
        guard toastStr.count > 0 else {
            return
        }
        #if DEBUG
        #else
        hideAllToast()
        #endif
        view.makeToast(toastStr, position: position)
    }
    
    func showToastOnWindow(_ toastStr: String) {
        guard toastStr.count > 0 else {
            return
        }
        #if DEBUG
        #else
        hideAllToast()
        #endif
        CommonUIUtil.mainWindow.makeToast(toastStr)
    }
    
    func hideAllToast() {
        view.hideAllToasts()
        CommonUIUtil.mainWindow.hideAllToasts()
    }
    
    func showHUD() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.9)
        hud.contentColor = UIColor.white
        hud.removeFromSuperViewOnHide = true
    }
    
    func hideHUD() {
        let result = MBProgressHUD.hide(for: view, animated: true)
        if !result {
            hideHUD()
        }
    }
}

