//
//  ActiveView.swift
//  Inlove
//
//  Created by ddkj on 2020/8/10.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit

public class ActiveView: UIView {
    @IBInspectable var lineCount: Int = 3
    @IBInspectable var lineWidth: CGFloat = 3.f
    @IBInspectable var lineColor: UIColor = UIColor.white
    
    lazy var activelayer = ActiveLayer(with: bounds, lineCount: lineCount, lineWidth: lineWidth, lineColor: lineColor)
    
//    override var isHidden: Bool {
//        set {
//            super.isHidden = newValue
//            if newValue {
//                activelayer.stopAnimation()
//            } else {
//                activelayer.startAnimation()
//            }
//        }
//
//        get {
//            return super.isHidden
//        }
//    }
    
    init(frame: CGRect, lineCount: Int = 3, lineWidth: CGFloat = 3.f, lineColor: UIColor = .white) {
        self.lineCount = lineCount
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        super.init(frame: frame)
        layer.addSublayer(activelayer)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(activelayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
//        activelayer.startAnimation()
    }
    
    public func startAnimation() {
        activelayer.startAnimation()
    }
    
    public func stopAnimation() {
        activelayer.startAnimation()
    }
}

class ActiveLayer: CALayer {
    var lineCount: Int
    var lineWidth: CGFloat
    var lineColor: UIColor
    
    fileprivate var lineMargin = 0.f
    fileprivate var isAnimated = false
    fileprivate var lineLayers = [CALayer]()
    
    fileprivate let animationDuration = 1.f
    
    init(with frame: CGRect, lineCount: Int = 3, lineWidth: CGFloat = 3.f, lineColor: UIColor = .white) {
        self.lineCount = lineCount
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        super.init()
        self.frame = frame
        createLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayers() {
        let height = bounds.size.height
        let width = bounds.size.width
        lineMargin = (width - CGFloat(lineCount) * lineWidth) / (CGFloat(lineCount) - 1.f)
        
        for i in 0 ..< 3 {
            let layer = CAShapeLayer()
            layer.lineWidth = lineWidth
            layer.strokeColor = lineColor.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineCap = .round
            layer.cornerRadius = lineWidth / 2
            let x =  CGFloat(i) * lineWidth + CGFloat(i) * lineMargin
            layer.frame = CGRect(x: x, y: 0, width: lineWidth, height: height)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            path.addLine(to: CGPoint(x: lineWidth / 2, y: height))
            
            layer.path = path.cgPath
            addSublayer(layer)
            lineLayers.append(layer)
        }
    }
    
    func startAnimation() {
        if isAnimated {
            return
        }
        isAnimated = true
        
        for i in 0 ..< 3 {
            let animation = CAKeyframeAnimation(keyPath: "strokeStart")
            animation.values = [0, 0.9, 0]
            animation.beginTime = CFTimeInterval(CGFloat(i) * (animationDuration / CGFloat(2 * lineCount)));
            animation.duration = CFTimeInterval(animationDuration);
            animation.repeatCount = .greatestFiniteMagnitude
            animation.isRemovedOnCompletion = false //必须设为false否则会被销毁掉
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            lineLayers[i].add(animation, forKey: nil)
        }
    }
    
    func stopAnimation() {
        if !isAnimated {
            return
        }
        isAnimated = false
        
        for lineLayer in lineLayers {
            lineLayer.removeAllAnimations()
        }
    }
}
