//
//  RankValueView.swift
//  Inlove
//
//  Created by ddkj on 2020/7/27.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit
import SnapKit

//import DDUtil

public enum RankValue {
    case treasure(value: Int)
    case charm(value: Int)
    
    var value: Int {
        switch self {
        case .treasure(let value):
            return value
        case .charm(let value):
            return value
        }
    }
}

fileprivate let imageViewLength = 15.f
fileprivate let leftSpace = 8.f
fileprivate let middleSpace = 3.f
fileprivate let rightSpace = 9.f

public class RankValueView: UIView {
    lazy var gradientLayer = { () -> CAGradientLayer in
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        return gradientLayer
    }()
    lazy var imageView = UIImageView()
    lazy var valueLabel = { () -> UILabel in
        let label = UILabel()
        label.font = BLUITheme.Font.juniorSubRegular
        label.textColor = BLUITheme.Color.juniorTextColor
        return label
    }()
    var valueNum = 0
    public var wealthValue: RankValue? {
        didSet {
            if wealthValue != nil {
                refreshUI()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public override var intrinsicContentSize: CGSize {
        var length = 0.f
        if let rankValue = wealthValue, rankValue.value != 0 {
            let valueStr = rankValue.value.toString
            let font: UIFont = BLUITheme.Font.juniorSubRegular
            let attributes = [NSAttributedString.Key.font : font]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin

            length = valueStr.boundingRect(with: CGSize(width: 1000, height: 20), options: option, attributes: attributes as [NSAttributedString.Key : Any], context:nil).width
            length = length + imageViewLength + leftSpace + rightSpace + middleSpace
        }
        
        return length > 0 ? CGSize(width: length, height: 20) : CGSize.zero
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

extension RankValueView {
    private func initViews() {
        addSubview(imageView)
        addSubview(valueLabel)
        layer.insertSublayer(gradientLayer, at: 0)
        setCornerRadius(10)
        initConstraints()
    }
    
    private func initConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(leftSpace)
            make.width.equalTo(imageViewLength)
            make.height.equalTo(imageViewLength)
            make.centerY.equalTo(self)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(middleSpace)
            make.centerY.equalTo(imageView)
        }
    }
    
    private func refreshUI() {
        switch wealthValue! {
        case .treasure(let value):
            imageView.image = UIImage(named: "profile_treasure_normal")
            valueLabel.text = "\(value)"
            gradientLayer.colors = [UIColor(hex: "FE6744").cgColor, UIColor(hex: "FEB74C").cgColor]
        case .charm(let value):
            imageView.image = UIImage(named: "profile_chram_normal")
            valueLabel.text = "\(value)"
            gradientLayer.colors = [UIColor(hex: "FF478A").cgColor, UIColor(hex: "EE8EF1").cgColor]
        }
        invalidateIntrinsicContentSize()
    }
}
