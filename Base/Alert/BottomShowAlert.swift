//
//  BottomShowAlert.swift
//  Inlove
//
//  Created by kuang on 2020/9/21.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit

open class BottomShowAlert: BaseAlertView {
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.showStyle = .bottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showStyle = .bottom
    }

    private lazy var bottomSureBtn: UIButton = {
         let btn = UIButton(type: .custom)
         btn.sizeToFit()
         btn.commonSureStyle()
         return btn
     }()
    
    private var cornerLayer: CAShapeLayer? = nil

    open override  func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func show(inView: BaseAlertShowInViewStyle = .window, _ animated: Bool = true) {
        if inView == .window && fullType == .horizontal && ScreenLayout.bottomBarHeight > 0{//适配iphonex，改变添加再window上的弹框高度
            self.height = self.height + ScreenLayout.bottomBarHeight
            if let maskLayer = self.cornerLayer { //如果cornerLayer存在，那么self的高度可能因为适配iphonex而更改，圆角的layer也得改
                let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ScreenLayout.screenWidth, height: self.height + ScreenLayout.bottomBarHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 18, height: 18))
                maskLayer.path = maskPath.cgPath
            }
        }
        super.show(inView: inView, animated)
    }
    
    //底部的确定按钮
    public func addBottomSureBtn(in superView: UIView? = nil, title: String = "确定", selector: Selector? = #selector(tapSureAction)) {
        let view = superView ?? self
        view.addSubview(self.bottomSureBtn)
        self.bottomSureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
            make.bottom.equalTo(-23)
        }
        self.bottomSureBtn.setTitle(title, for: .normal)
        if let selector = selector{
            self.bottomSureBtn.addTarget(self, action: selector, for: .touchUpInside)
        }
    }
    
     //顶部的圆角
    public func addTopCornerRadious(in view: UIView){
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ScreenLayout.screenWidth, height: view.height), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 18, height: 18))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        if view == self {
            self.cornerLayer = maskLayer
        }
    }
}
