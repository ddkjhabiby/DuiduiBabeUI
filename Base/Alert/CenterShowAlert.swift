//
//  CenterShowAlert.swift
//  Inlove
//
//  Created by kuang on 2020/9/21.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit


public enum CenterButtonStyle {
    case cancel
    case sure
    
    public static let width = 104
    static let height = 40
    static let bottom = 20
}

public enum CenterViewConstraint {
    case none
    case best
    case customValue(value: CGFloat)
    case onlyView(view: UIView)
    case view(view: UIView, value: CGFloat)
    case superView
}

open class CenterShowAlert: BaseAlertView {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.showStyle = .center
        self.fullType = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showStyle = .center
        self.fullType = .none
    }

    private lazy var btns: [UIButton] = {
        let array = [UIButton]()
        return array
    }()
   
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.font = BLUITheme.Font.seniorSubMedium
        titleLabel.textColor = BLUITheme.Color.mainTextColor
        return titleLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel.init()
        messageLabel.font = BLUITheme.Font.middleSubRegular
        messageLabel.textColor = BLUITheme.Color.mainSubTextColor
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    private lazy var btnBgView: UIView = {
        let btnBgView = UIView.init()
        btnBgView.backgroundColor = UIColor.clear
        return btnBgView
    }()
    
    private lazy var titileIcon: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
   

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.fullType = .none
    }
    
}

// MARK: public methods
extension CenterShowAlert{
    //添加标题
    public func addTitle(in superView: UIView? = nil, title: String) {
        let view = superView ?? self
        view.addSubview(self.titleLabel)
        self.titleLabel.text = title
        self.addTitleBottomConstrait(bottomConstraint: .none)
    }
    public func addAttributeTitle(in superView: UIView? = nil, title: NSAttributedString?) {
        let view = superView ?? self
        view.addSubview(self.titleLabel)
        self.titleLabel.attributedText = title
        self.addTitleBottomConstrait(bottomConstraint: .none)
    }
    
    //添加标题图标
    public func addTitleIcon(in superView: UIView? = nil, icon: String,  width: CGFloat = 75, height: CGFloat = 75) {
        let view = superView ?? self
        view.addSubview(self.titileIcon)
        titileIcon.image = UIImage.init(named: icon)
        titileIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo( -height/2.0)
            maker.centerX.equalTo(view)
            maker.width.equalTo(width)
            maker.height.equalTo(height)
        }
     }
    
    //添加标题向下的约束，如果没有message，那么就得添加
    public func addTitleBottomConstrait(in superView: UIView? = nil, bottomConstraint: CenterViewConstraint = .none){
        self.titleLabel.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(30)
            maker.centerX.equalTo(self.titleLabel.superview!)
            maker.left.greaterThanOrEqualTo(20)
            maker.right.lessThanOrEqualTo(-20)
            
            switch bottomConstraint{
            case let .view(view: layoutView, value: layoutValue):
                maker.bottom.equalTo(layoutView.snp.top).offset(layoutValue)
            case let .onlyView(view: layoutView):
                maker.bottom.equalTo(layoutView.snp.top).offset(-30)
            case .superView:
                maker.bottom.equalTo(-30)
            case .best:
                if self.btnBgView.superview == nil {
                    maker.bottom.equalTo(-30)
                }
                else{
                    maker.bottom.equalTo(self.btnBgView.snp.top).offset(-30)
                }
            default:
                break
            }
        }
    }
    
    //添加文字内容
    public func addMessage(in superView: UIView? = nil, message: String?, bottomConstraint: CenterViewConstraint = .none, topConstraint: CenterViewConstraint = .best) {
        guard let message = message else {
            return
        }
         let view = superView ?? self
         view.addSubview(self.messageLabel)
         self.messageLabel.text = message
         self.messageLabel.snp.makeConstraints { (maker) in
            switch topConstraint{
            case let .view(view: layoutView, value: layoutValue):
                maker.top.equalTo(layoutView.snp.bottom).offset(layoutValue)
            case let .onlyView(view: layoutView):
                maker.top.equalTo(layoutView.snp.bottom).offset(18)
            case .superView:
                maker.top.equalTo(40)
            case .best:
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(18)
            case let .customValue(value):
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(value)
            default:
                break
            }
            
            switch bottomConstraint{
            case let .view(view: layoutView, value: layoutValue):
                maker.bottom.equalTo(layoutView.snp.top).offset(layoutValue)
            case let .onlyView(view: layoutView):
                maker.bottom.equalTo(layoutView.snp.top).offset(-30)
            case .superView:
                maker.bottom.equalTo(-30)
            case .best:
                if self.btnBgView.superview == nil {
                    maker.bottom.equalTo(-30)
                }
                else{
                    maker.bottom.equalTo(self.btnBgView.snp.top).offset(-30)
                }
            default:
                break
            }
            
            maker.centerX.equalTo(view)
            maker.left.greaterThanOrEqualTo(20)
            maker.right.lessThanOrEqualTo(-20)
        }
     }
    
    //底部的确定和取消按钮
    //注意，所有的按钮必须都添加在同一个suprview上
    public func addBtn(in superView: UIView? = nil, title: String = "确定", tag: Int = 0, style: CenterButtonStyle = .sure, selector: Selector? = #selector(tapSureAction), btnWidth: Int = CenterButtonStyle.width) {
        let view = superView ?? self
        if self.btnBgView.superview == nil {
            addBtnBg(in: view)
        }
        
        let btn = UIButton(type: .custom)
        btn.tag = tag
        self.btnBgView.addSubview(btn)
        btn.setTitle(title, for: .normal)
        btn.setCornerRadius(CGFloat(CenterButtonStyle.height)/2.0)
        if let selector = selector{
            btn.addTarget(self, action: selector, for: .touchUpInside)
        }
        switch style {
         case .cancel:
            btn.backgroundColor = BLUITheme.Color.backgroundColor
            btn.setBorder( 1.5, borderColor: BLUITheme.Color.sperateColor.cgColor)
            btn.setTitleColor(BLUITheme.Color.mainTextColor, for: .normal)
         case .sure:
            btn.setHoriGredientBackground().frame = CGRect(x: 0, y: 0, width: btnWidth, height: CenterButtonStyle.height)
        }
         
        self.btns.append(btn)
         
        let isOnlyOne = self.btns.count == 1
        if isOnlyOne {
             btn.snp.remakeConstraints { (maker) in
                 maker.width.equalTo(btnWidth)
                 maker.top.left.right.bottom.equalTo(self.btnBgView)
             }
        }
        else{
             var lastItem: UIButton? = nil
             for item in self.btns {
                
                 if let leftView = lastItem {
                    if item == self.btns.last {
                        item.snp.remakeConstraints { (maker) in
                            maker.width.equalTo(btnWidth)
                            maker.top.bottom.equalTo(self.btnBgView)
                            maker.left.equalTo(leftView.snp.right).offset(14)
                            maker.right.equalTo(self.btnBgView.snp.right)
                        }
                    }
                    else{
                        btn.snp.remakeConstraints { (maker) in
                            maker.width.equalTo(btnWidth)
                            maker.top.bottom.equalTo(self.btnBgView)
                            maker.left.equalTo(leftView.snp.right).offset(14)
                        }
                    }
                 }
                 else{
                    item.snp.remakeConstraints { (maker) in
                        maker.width.equalTo(btnWidth)
                        maker.top.bottom.equalTo(self.btnBgView)
                        maker.left.equalTo(self.btnBgView.snp.left)
                     }
                 }
                 lastItem = item
             }
        }
    }
    
     //顶部的圆角
    public func addCornerRadious(in view: UIView){
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.width, height: view.height), byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 18, height: 18))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }

}

fileprivate extension CenterShowAlert{
    //添加按钮背景，添加按钮前，必须先添加这个
    private func addBtnBg(in superView: UIView? = nil){
        let view = superView ?? self
        view.addSubview(self.btnBgView)
        self.btnBgView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-CenterButtonStyle.bottom)
            maker.centerX.equalTo(view)
            maker.height.equalTo(CenterButtonStyle.height)
            maker.width.greaterThanOrEqualTo(0)
        }
    }
}
