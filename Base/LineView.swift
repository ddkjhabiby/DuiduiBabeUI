//
//  LineView.swift
//  Inlove
//
//  Created by kuang on 2020/7/24.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit


//下划线格式
public enum LineViewBackgroundStyle{
    case normal
    case eidting
    case error
};

open class LineView: UIView {

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [BLUITheme.Color.sperateColor.cgColor, BLUITheme.Color.sperateColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()
    
    public var style: LineViewBackgroundStyle = .normal
    {
        didSet{
            self.updateBackGroundColor()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = BLUITheme.Color.sperateColor
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
    
    
   private  func updateBackGroundColor(){
    var colors = [BLUITheme.Color.sperateColor.cgColor, BLUITheme.Color.sperateColor.cgColor]
    switch style {
    case .normal:
        break
    case .eidting:
        colors = BLUITheme.Color.mainHoriGredientColors.reversed()
    case .error:
        colors = [BLUITheme.Color.tipsColor.cgColor, BLUITheme.Color.tipsColor.cgColor]
    }
    self.gradientLayer.colors = colors
    }
   

}
