//
//  HoUIViewExtensions.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/24.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 从nib获取UIView
    public class var nibView: UIView {
        get {
            let nibNamed = String(describing: self)
            if let view = UINib(nibName: nibNamed, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView {
                return view
            }
            fatalError("can not load nib view of \(self)")
        }
    }
    
}
