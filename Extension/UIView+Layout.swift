//
//  UIView+Layout.swift
//  DDUI
//
//  Created by kuang on 2020/12/4.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            frame.size.width = newValue
        }
    }
    
    var size: CGSize {
        get{
            return self.frame.size
        }
        set{
            frame.size = newValue
        }
    }
    
    var bottom: CGFloat {
        get{
            return frame.origin.y + frame.size.height;
        }
        set{
            frame.origin.y = newValue - frame.size.height;
        }
    }
}
