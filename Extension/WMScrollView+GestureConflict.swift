//
//  WMScrollView+GestureConflict.swift
//  Inlove
//
//  Created by yangjie on 2020/10/10.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import WMPageController

extension WMScrollView {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p = panGestureRecognizer.translation(in: self)
        if contentOffset.x <= 0 && p.x > 0 {
            return false
        }
        if contentOffset.x + UIScreen.width >= contentSize.width && p.x < 0 {
            return false
        }
        return true
    }
}
