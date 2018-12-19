//
//  HoXib.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

struct HoNib {
    
    /// 从nib获取UIView
    ///
    /// 使用方式 let view = HoNib.instantiateView(NibView.self)
    ///
    /// - parameter identifier: UIView.self的类名
    /// - returns: 类的实例变量
    public static func instantiateView<T>(_ identifier: T.Type = T.self) -> T {
        
        let nibNamed = String(describing: identifier)
        if let view = UINib(nibName: nibNamed, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T {
            return view
        }
        fatalError("can not load nib view of \(identifier)")
    }
}
