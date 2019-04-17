//
//  HoUIColorExtensions.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

extension UIColor {
    /// 16进制颜色转UIColor
    ///
    /// Usage: let color = UIColor("#000000")
    ///
    /// - parameter hexString: 16进制字符串 - "#000000" or "0x000000"
    /// - parameter alpha: 透明度 0.0 - 1.0
    /// - returns: UIColor?
    public convenience init?(_ hexString: String, alpha: CGFloat = 1.0) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 获取随机色
    public class var random: UIColor {
        let randomRed   = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue  = CGFloat.random()
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

fileprivate extension CGFloat {
    /// 随机数
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}
