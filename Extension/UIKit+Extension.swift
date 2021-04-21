//
//  UIKit+Extension.swift
//  Inlove
//
//  Created by ddkj on 2020/7/17.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa

import RxSwift

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

public extension UIView {
    func setCornerRadius(_ radius: CGFloat? = nil) {
        if let radius = radius{
            layer.cornerRadius = radius
        }
        else{
            layer.cornerRadius = self.height/2.0
        }
        layer.masksToBounds = true
    }
    
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner) {
        setCornerRadius(radius, corners: corners, bounds: bounds)
    }
    
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner, bounds: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path
        self.layer.mask = layer
        layer.masksToBounds = true
    }
    
    func setBorder(_ width: CGFloat = 1, borderColor: CGColor) {
        layer.borderWidth = width
        layer.borderColor = borderColor
    }
    
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    enum GradientDirection {
         case topToBottom//从上到下
         case leftToRight//从左到右
         case upleftToLowright//左上到右下
         case uprightToLowleft//右上到左下
     }
    
    static func gradientColorImage(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors, size: CGSize = CGSize(width: 1, height: 1), direction: GradientDirection = .leftToRight, alpha: CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        if (alpha < 1 && alpha > 0) {
            context.setAlpha(alpha)
        }
        let colorSpace = colors.first!.colorSpace
        let gradient = CGGradient(colorsSpace: colorSpace,colors: colors as CFArray, locations: nil)!
        let start: CGPoint
        let end: CGPoint
        switch (direction) {
        case .topToBottom:
            start = CGPoint(x: 0.0, y: 0.0)
            end = CGPoint(x: 0.0, y: rect.size.height)
        case .leftToRight:
            start = CGPoint(x: 0.0, y: 0.0)
            end = CGPoint(x: rect.size.width, y: 0.0)
        case .upleftToLowright:
            start = CGPoint(x: 0.0, y: 0.0)
            end = CGPoint(x: rect.size.width, y: rect.size.height)
        case .uprightToLowleft:
            start = CGPoint(x: rect.size.width, y: 0.0)
            end = CGPoint(x: 0.0, y: rect.size.height)
        }
        context.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
         let rect = CGRect(origin: .zero, size: size)
         UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
         let context = UIGraphicsGetCurrentContext()!
         context.setFillColor(color.cgColor)
         context.fill(rect)
         let image = UIGraphicsGetImageFromCurrentImageContext()!
         UIGraphicsEndImageContext()
         return image
    }
    
    @discardableResult
    func setHoriGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors, bounds: CGRect? = nil) -> CAGradientLayer {
        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds ?? self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let btn = self as? UIButton, let imageView = btn.imageView {
            bringSubviewToFront(imageView)
        }
        
        return gradientLayer
    }
    
    @discardableResult
    func setVericalGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors, bounds: CGRect? = nil) -> CAGradientLayer {
        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds ?? self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let btn = self as? UIButton, let imageView = btn.imageView {
            bringSubviewToFront(imageView)
        }
        
        return gradientLayer
    }
    
    @discardableResult
    func setRightDipGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors) -> CAGradientLayer {
        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let btn = self as? UIButton, let imageView = btn.imageView {
            bringSubviewToFront(imageView)
        }
        
        return gradientLayer
    }
    
    @discardableResult
    func setLeftDipGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors) -> CAGradientLayer {
        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let btn = self as? UIButton, let imageView = btn.imageView {
            bringSubviewToFront(imageView)
        }
        
        return gradientLayer
    }
    
//    func setVericalGredientBorder(borderColors: [CGColor] = BLUITheme.Color.mainHoriGredientColors, fillColor: CGColor = UIColor.white.cgColor, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 2 ) -> CAGradientLayer {
//        if let gradientLayer = layer.sublayers?[0], gradientLayer is CAGradientLayer {
//            gradientLayer.removeFromSuperlayer()
//        }
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = borderColors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        
//        let shape = CAShapeLayer()
//        shape.lineWidth = borderWidth
//        shape.path = UIBezierPath(rect: bounds).cgPath
//        shape.strokeColor = UIColor.black.cgColor
//        shape.fillColor = fillColor
//        shape.cornerRadius = cornerRadius
//        gradientLayer.mask = shape
//        layer.insertSublayer(gradientLayer, at: 0)
//        return gradientLayer
//    }
}

public extension Reactive where Base: UIControl {
    var controlTap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

public extension UIControl {
    var controlTap: ControlEvent<Void> {
        return rx.controlTap
    }
}

public extension UIImage {
    func squareImage() -> UIImage? {
        let width = min(size.width, size.height)
        let finalSize = CGSize(width: width, height: width)
        var finalImage: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(finalSize, false, UIScreen.main.scale)
        draw(at: CGPoint(x: 0, y: 0))
        finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    static func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }
}


public extension CALayer {
    func setRightDipGredientBackground(colors: [CGColor] = BLUITheme.Color.mainHoriGredientColors) -> CAGradientLayer {
        if let gradientLayer = sublayers?[0], gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}
