//
//  CommonUIUtil.swift
//  Inlove
//
//  Created by kuang on 2020/7/20.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

public struct CommonUIUtil {
    public static let appDelegate = (UIApplication.shared.delegate)
    public static let mainWindow = UIApplication.shared.delegate!.window!!
    
    public static func rootViewController() -> UIViewController?{
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    public static func topViewController() -> UIViewController? {
           return UIApplication.shared.topViewController()
       }

    public static func toast() -> BaseViewControllerProtocol? {
        return UIApplication.shared.topViewController() as? BaseViewControllerProtocol
    }
    
    public static func popToLastIndex(index: Int, navigationController: UINavigationController, animated:Bool = true) {
        var backVC = navigationController.viewControllers.first
        if navigationController.viewControllers.count > index {
            backVC = navigationController.viewControllers[navigationController.viewControllers.count - index - 1]
        }
        if let backVC = backVC{
            navigationController.popToViewController(backVC, animated: animated)
        }
    }
    
    public static func popToClass(className: String, navigationController: UINavigationController?, animated:Bool = true) {
        guard let navigationController = navigationController else {
            return
        }
        let count = navigationController.viewControllers.count
        for i in (0...(count - 1)) .reversed(){
            let controller = navigationController.viewControllers[i]
            if className == controller.className{
                navigationController.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
   
    
    
    
    //避免切换时，有present会导致的内存泄露
//    static func safe_switchWindowRoot(with newRoot: UIViewController){
//        let topVc = UIApplication.shared.topViewController()
//
//        var needDismissVC: UIViewController? = nil
//        if topVc?.presentingViewController != nil{
//            needDismissVC = topVc
//        }
//        else if topVc?.navigationController?.presentingViewController != nil{
//            needDismissVC = topVc?.navigationController
//        }
//
//        if let disMissVC = needDismissVC{
//            disMissVC.dismiss(animated: false, completion: {
//                CommonUIUtil.safe_switchWindowRoot(with: newRoot)
//            })
//        }
//        else{
//            appDelegate.window!.rootViewController = newRoot
//        }
//    }
}
