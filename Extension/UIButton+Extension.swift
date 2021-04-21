//
//  LoginButton.swift
//  Inlove
//
//  Created by kuang on 2020/7/24.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit


public extension UIButton {

    func commonSureStyle() {
          //       获取验证码按钮
        self.setCornerRadius(25)
        self.setBackgroundImage(UIView.gradientColorImage(), for: .normal)
        self.setBackgroundImage(UIView.image(with: BLUITheme.Color.sperateColor), for: .disabled)
        self.setTitleColor(BLUITheme.Color.backgroundColor, for: .normal)
        self.setTitleColor(BLUITheme.Color.middleTextColor, for: .disabled)
        self.titleLabel?.font = BLUITheme.Font.middleHeavy
    }
    
//    func setHoriGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors, insets: UIEdgeInsets = UIEdgeInsets.zero) -> CAGradientLayer {
//        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
//            gradientLayer.removeFromSuperlayer()
//        }
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = bounds.inset(by: insets)
//        gradientLayer.colors = colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//
//        if insets != UIEdgeInsets.zero {
//            gradientLayer.cornerRadius = gradientLayer.frame.height / 2.0
//        }
//
//        layer.insertSublayer(gradientLayer, at: 0)
//        if let imageView = imageView {
//            bringSubviewToFront(imageView)
//        }
//        return gradientLayer
//    }

}

//扩大按钮点击范围
public extension UIButton{
    ///需要扩充的边距
    var hitTestEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "custom_hitTestEdgeInsets".hashValue)!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "custom_hitTestEdgeInsets".hashValue)!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    
    ///是否响应
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (hitTestEdgeInsets! == UIEdgeInsets.zero) || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        else {
            let expandArea = self.bounds.inset(by: hitTestEdgeInsets!)
            return expandArea.contains(point)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
}
