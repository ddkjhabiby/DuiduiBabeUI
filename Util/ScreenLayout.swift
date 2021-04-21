//
//  ScreenLayout.swift
//  Inlove
//
//  Created by kuang on 2020/7/20.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import SwiftyUtils

public struct ScreenLayout {

    public static var isFullScreenDevice: Bool {
        (max(UIScreen.width, UIScreen.height)/min(UIScreen.width, UIScreen.height)) > 1.78 ? true : false;
    }
    public static var statusBarHeight: CGFloat {
        UIScreen.statusBarHeight
    }
    public static var bottomBarHeight: CGFloat {
        self.isFullScreenDevice ? 34.0 : 0.0
    }
    public static var topBarHeight: CGFloat {
        self.isFullScreenDevice ? 88.0 : 64.0
    }
    public static var tabBarHeight: CGFloat {
        49
    }
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
}
