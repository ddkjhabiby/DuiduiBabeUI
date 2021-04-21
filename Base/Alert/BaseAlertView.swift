//
//  BaseAlertView.swift
//  Inlove
//
//  Created by kuang on 2020/8/20.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

public enum BaseAlertShowType{
    case center
    case top
    case bottom
}

public enum BaseAlertFullType: Equatable{
    case none
    case horizontal
    case vertical
    case both
}


public enum BaseAlertBackgroundStyle{
    case dark
    case clear
}


//页面事件
public enum BaseAlertButtonTag: Int{
    case cancel = 0
    case sure = 1
}


public enum BaseAlertShowInViewStyle: Equatable{
    case window
    case root
    case parent(view: UIView)
}

open class BaseAlertView: UIView, ViewProtocol {
    public static let dismissAllAlertNotify = "dismissAllAlertNotify"
    
    var needTapDismiss = true  //true，点击透明区域会隐藏
    public var showStyle = BaseAlertShowType.center
    public var backgroundStyle = BaseAlertBackgroundStyle.dark
    open var fullType = BaseAlertFullType.both
    open var tapBtnAutoDismiss = true
    
    public var buttonAction: ((_ tag: Int)->())? = nil
    
    public var deinitBlock: (()->())? = nil

    private var parentView: UIView? = nil
    
    private lazy var bgView: UIView = {
        let _bgView = UIView.init()
        switch self.backgroundStyle{
        case .dark:
            _bgView.backgroundColor = UIColor.black
        case .clear:
            _bgView.backgroundColor = UIColor.clear
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapDismiss))
        _bgView.addGestureRecognizer(tapGesture)
        return _bgView
    }()
    
    
    private lazy var rightHiddenBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "alert_close"), for: .normal)
        btn.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initAlert()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initAlert()
    }
    
    deinit {
        deinitBlock?()
        NotificationCenter.default.removeObserver(self)
    }
    func initAlert() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginOutNotify), name: Notification.Name(rawValue: BaseAlertView.dismissAllAlertNotify), object: nil)
    }
    
    @objc func loginOutNotify(notification: Notification){
        self.dismiss()
    }
    
    open func dismiss(){
        var duration: Double = 0
        var options: UIView.AnimationOptions = .layoutSubviews
        var block: (()->()) = {}
        switch self.showStyle {
        case .center:
            duration = 0.1
            options = .curveLinear
            block = {[weak self] in
                guard let self = self else{return}
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            };
        case .top:
            duration = 0.3
            block = {[weak self] in
                guard let self = self else{ return }
                self.bottom = 0
            };
        case .bottom:
            duration = 0.3
            block = {[weak self] in
                guard let self = self else{return}
                self.y = self.fetchParentView().height
            };
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: block) {[weak self] (finished) in
            guard let self = self else{return}
            self.bgView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    //fullType:是否填满父节点，默认横竖都填满
    open func show(inView: BaseAlertShowInViewStyle = .window, _ animated: Bool = true){
        switch inView {
        case .window:
            self.parentView = CommonUIUtil.mainWindow
        case .root:
            self.parentView = CommonUIUtil.rootViewController()?.view
        case let .parent(view):
            self.parentView = view
        }
        let parent = self.fetchParentView()
        parent.addSubview(self.bgView)
        self.bgView.frame = parent.bounds
        
        switch fullType {
        case .both:
            self.width = parent.width
            self.height = parent.height
        case .horizontal:
            self.width = parent.width
        case .vertical:
            self.height = parent.height
        default:
            break
        }
        
        self.center = CGPoint(x:parent.width/2, y: parent.height/2)
        parent.addSubview(self)
        if animated {
            self.showAnimation()
        }
        
    }

}

// MARK: private methods
fileprivate extension BaseAlertView {
    func fetchParentView() -> UIView{
        if let parent = self.parentView {
            return parent
        }
        
        return CommonUIUtil.mainWindow
    }
    
    func showAnimation() {
        switch self.showStyle {
        case .center:
            let animation = CAKeyframeAnimation.init(keyPath: "transform")
            animation.duration = 0.3
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.values = [CATransform3DMakeScale(0.1, 0.1, 1.0),
                                CATransform3DMakeScale(1.2, 1.2, 1.0),
                                CATransform3DMakeScale(0.9, 0.9, 0.9),
                                CATransform3DMakeScale(1.0, 1.0, 1.0)]
            animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            self.layer.add(animation, forKey: nil)
        case .top:
            self.bottom = 0
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.y = 0
            }
        case .bottom:
            self.y = fetchParentView().height
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else{return}
                self.bottom = self.fetchParentView().height
            }
        }
        
        switch self.backgroundStyle {
        case .dark:
            bgView.alpha = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else{return}
                self.bgView.alpha = 0.7
            }
        default:
            break
        }
    }
}


// MARK: public action
extension BaseAlertView {
    @objc open func tapDismiss() {
        if self.needTapDismiss {
            self.dismiss()
        }
    }
    
    @objc open func tapSureAction(sender: UIButton) {
        self.buttonAction?(sender.tag)
        if tapBtnAutoDismiss {
            self.dismiss()
        }
    }
}


// MARK:ui补充
public extension BaseAlertView {
    //右上角的x
    func addRightHiddenBtn(in superView: UIView? = nil) {
        let view = superView ?? self
        view.addSubview(self.rightHiddenBtn)
        self.rightHiddenBtn.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.right.equalTo(-9)
            make.width.height.equalTo(44)
        }
    }
}

