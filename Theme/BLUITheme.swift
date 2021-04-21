//
//  BLUITheme.Color.swift
//  Inlove
//
//  Created by kuang on 2020/8/10.
//  Copyright © 2020 duiud. All rights reserved.
//
import UIKit
import SwiftyUtils


public struct BLUITheme{
    
    public struct Color {
    
    //    //背景色
        public static var mainColor                = UIColor(hex: "74E5D9")
        public static var mainSubColor             = UIColor(hex: "4CB8F4")
        public static var middleColor              = UIColor(hex: "FF60C9")
        public static var middleSubColor           = UIColor(hex: "6EC3F1")
        public static var tipsColor                = UIColor(hex: "F95447")
        public static var sperateColor             = UIColor(hex: "EDF2FA")
        public static var backgroundColor          = UIColor(hex: "FFFFFF")
        public static var controllBackGroundColor  = UIColor(hex: "F4F8FF")

        //字体色
        public static var mainTextColor            = UIColor(hex: "222222")
        public static var mainSubTextColor         = UIColor(hex: "666666")
        public static var middleTextColor          = UIColor(hex: "999999")
        public static var middleSubTextColor       = UIColor(hex: "B3B3B3")
        public static var juniorTextColor          = UIColor(hex: "FFFFFF")
        
        public static var newMainColor = UIColor(hex: "FF67BB")
        public static var whieteSperateColor = UIColor(hex: "F4F8FF")
        public static var buttonBorder = UIColor(hex: "EDF2FA")
        
        //文字
        public static var mainBlackTextColor = UIColor(hex: "0E0F16")
        public static var newMiddleTextColor = UIColor(hex: "D8D8D8")
        
        //特征色
        public static var goldColor                = UIColor(hex: "FEDC01")
        
        //渐变色
        public static var mainHoriGredientColors   = [UIColor(hex: "FF9482").cgColor, UIColor(hex: "F869D5").cgColor, UIColor(hex: "7D77FF").cgColor]
        public static var mainSubHoriGredientColors   = [UIColor(hex: "FF59BF").cgColor, UIColor(hex: "7D77FF").cgColor]
        public static var middleHoriGredientColors   = [UIColor(hex: "13C1DD").cgColor, UIColor(hex: "00D0C6").cgColor]
        public static let juniorHoriGredientColors   = [UIColor(hex: "FF8D7C").cgColor, UIColor(hex: "FF69C0").cgColor]
        public static let mainNewSubHoriGredientColors   = [UIColor(hex: "74E5D9").cgColor, UIColor(hex: "4CB8F4").cgColor]
            
    }
    
    
    public struct Font{
        public static let superMedium         = UIFont(name: "PingFangSC-Medium", size: 28.0)! //主要用于大标题
        public static let seniorMedium         = UIFont(name: "PingFangSC-Medium", size: 24.0)! //主要用于大标题
        public static let seniorSubMedium      = UIFont(name: "PingFangSC-Medium", size: 18.0)! //主要用于导航主标题
        public static let seniorSubHeavy      = UIFont(name: "Helvetica-Bold", size: 18.0)! //主要用于导航主标题
        public static let middleHeavy         = UIFont.boldSystemFont(ofSize: 16) //主要用于内容区域一级主标题
        public static let juniorHeavy         = UIFont.boldSystemFont(ofSize: 12) //
        public static let seniorSubRegular      = UIFont(name: "PingFangSC-Regular", size: 18.0)! //主要用于导航主标题
        public static let middleRegular         = UIFont(name: "PingFangSC-Regular", size: 16.0)! //主要用于内容区域一级主标题
        public static let middleSubRegular     = UIFont(name: "PingFangSC-Regular", size: 14.0)! //主要用于内容区域二级主标题
        public static let juniorRegular        = UIFont(name: "PingFangSC-Regular", size: 12.0)! //主要用于内容区域辅助描述文字
        public static let juniorSubRegular     = UIFont(name: "PingFangSC-Regular", size: 10.0)! //主要用于内容区域次描述文字
    }
}

