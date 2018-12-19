//
//  HoCGRectExtensions.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

extension CGRect {
    
    /// origin.x
    public var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }
    
    /// origin.y
    public var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }
    
    /// size.width
    public var w: CGFloat {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }
    
    /// size.height
    public var h: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }
    
}
