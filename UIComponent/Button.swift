//
//  Button.swift
//  Inlove
//
//  Created by yangjie on 2020/11/17.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
}
