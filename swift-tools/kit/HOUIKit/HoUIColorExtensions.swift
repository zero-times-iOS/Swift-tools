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
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red: CGFloat   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green: CGFloat = CGFloat((hex & 0x00FF00) >> 16) / 255.0
            let blue: CGFloat  = CGFloat((hex & 0x0000FF) >> 16) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
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
