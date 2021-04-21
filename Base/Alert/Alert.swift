//
//  Alert.swift
//  Inlove
//
//  Created by kuang on 2020/10/10.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
public final class Alert: CenterShowAlert{
    
    /*
    needTapDismiss：true，点击透明区域会隐藏，
    buttons： 按钮文案，有按钮则传，没有可以不传
    */
    public class func textAlert(title: String?, message: String?, needTapDismiss: Bool = true, tapBtnAutoDismiss: Bool = true, buttons: [String]?, action: ((_ index: Int) -> ())?) -> Alert {
        let alertView = Alert.init()
        alertView.fullType = .none
        alertView.addTitle(title: title ?? "")
        alertView.tapBtnAutoDismiss = tapBtnAutoDismiss
        if let buttons = buttons {
            for i in 0 ..< buttons.count {
                alertView.addBtn(title: buttons[i], tag: i, style: (buttons.count != 1 && i == 0) ? .cancel : .sure, selector: #selector(tapSureAction))
            }
        }
        
        if let message = message{
            alertView.addMessage( message: message, bottomConstraint: .best, topConstraint: .best)
        }
        else{
            alertView.addTitleBottomConstrait(bottomConstraint: .best)
        }
        alertView.needTapDismiss = needTapDismiss
        alertView.buttonAction = action
        
        return alertView
    }
    
    public class func attTextAlert(title: NSAttributedString?, message: String?, needTapDismiss: Bool = true, tapBtnAutoDismiss: Bool = true, buttons: [String]?, action: ((_ index: Int) -> ())?) -> Alert {
        let alertView = Alert.init()
        alertView.fullType = .none
        alertView.addAttributeTitle(title: title)
        alertView.tapBtnAutoDismiss = tapBtnAutoDismiss
        if let buttons = buttons {
            for i in 0 ..< buttons.count {
                alertView.addBtn(title: buttons[i], tag: i, style: (buttons.count != 1 && i == 0) ? .cancel : .sure, selector: #selector(tapSureAction))
            }
        }
        
        if let message = message{
            alertView.addMessage( message: message, bottomConstraint: .best, topConstraint: .best)
        }
        else{
            alertView.addTitleBottomConstrait(bottomConstraint: .best)
        }
        alertView.needTapDismiss = needTapDismiss
        alertView.buttonAction = action
        
        return alertView
    }
    
    
    /*
    needTapDismiss：true，点击透明区域会隐藏，
    buttons： 按钮文案，有按钮则传，没有可以不传
    */
    public class func textIconAlert(titleIcon: String, message: String?, needTapDismiss: Bool = true, tapBtnAutoDismiss: Bool = true, buttons: [String]?, action: ((_ index: Int) -> ())?) -> Alert {
        let alertView = Alert.init()
        alertView.fullType = .none
        alertView.addTitleIcon(icon: titleIcon)
        alertView.layer.masksToBounds = false
        alertView.addTitle(title: "")
        alertView.tapBtnAutoDismiss = tapBtnAutoDismiss
        if buttons != nil {
            for i in 0 ..< buttons!.count {
                alertView.addBtn(title: buttons![i], tag: i, style: i == 0 ? .cancel : .sure, selector: #selector(tapSureAction))
            }
        }
        
        if let message = message{
            alertView.addMessage( message: message, bottomConstraint: .best, topConstraint: .customValue(value: 28))
        }
        else{
            alertView.addTitleBottomConstrait(bottomConstraint: .best)
        }
        alertView.needTapDismiss = needTapDismiss
        alertView.buttonAction = action
        
        return alertView
    }
    
    public class func textRxAlert(title: String?, message: String?, needTapDismiss: Bool = true, tapBtnAutoDismiss: Bool = true, buttons: [String]?) -> Single<Int>{
        let observable = Single<Int>.create { single in
            let alert = Alert.textAlert(title: title, message: message, needTapDismiss: needTapDismiss, buttons: buttons) { (index) in
                single(.success(index))
            }
            alert.tapBtnAutoDismiss = tapBtnAutoDismiss
            alert.show()
            return Disposables.create()
        }
        return observable
    }
    
    
    
    public class func showTextAlert(title: String?, message: String?, needTapDismiss: Bool = true, tapBtnAutoDismiss: Bool = true, buttons: [String]?) -> Single<Int> {
        let observable = Single<Int>.create { single in
            let alert = Alert.textAlert(title: title, message: message, needTapDismiss: needTapDismiss, buttons: buttons) { (index) in
                single(.success(index))
            }
            alert.tapBtnAutoDismiss = tapBtnAutoDismiss
            alert.show()
            return Disposables.create()
        }
        return observable
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setCornerRadius(12)
    }
    
    public override func show(inView: BaseAlertShowInViewStyle = .window, _ animated: Bool = true){
        super.show(inView: inView, animated)
        self.snp.makeConstraints { (maker) in//如果不给self添加约束，只用frame，那么self会根据frame被添加默认约束，从而导致约束报错，并且无法被子节点撑大
            maker.center.equalTo(self.superview!.center)
            maker.width.equalTo(270)
        }
    }
}

