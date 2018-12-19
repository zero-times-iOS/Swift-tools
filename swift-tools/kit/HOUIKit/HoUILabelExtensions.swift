//
//  HoUILabelExtensions.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 动画设置text
    ///
    /// - parameter text: 显示文字
    /// - parameter animated: 是否显示动画 default is true
    /// - parameter duration: 动画时长 default is 0.3
    public func setText(_ text: String?, animated: Bool = true, duration: TimeInterval = 0.3) {
        
        if animated {
            UIView.transition(with: self, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.text = text
            }, completion: nil)
        }
        else {
            self.text = text
        }
    }
    
}
