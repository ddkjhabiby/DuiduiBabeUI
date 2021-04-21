//
//  ViewProtocol.swift
//  Inlove
//
//  Created by ddkj on 2020/7/17.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewProtocol {
    
}

public extension ViewProtocol where Self: UIView {
    
    static func loadNib(_ nibName: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibName ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
    
}
