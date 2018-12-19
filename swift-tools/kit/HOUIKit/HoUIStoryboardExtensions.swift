//
//  HoUIStoryboardExtensions.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// 获取当前设置的主UIStoryboard
    ///
    /// 使用方式: let mainStoryboard = UIStoryboard.main
    ///
    /// - returns: 主storyboard
    public static var main: UIStoryboard? {
        let bundle = Bundle.main
        if let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String {
            return UIStoryboard(name: name, bundle: bundle)
        }
        return nil
    }
    
    /// 从Storyboard获取ViewController
    ///
    /// - parameter identifier: 需要在Storyboard设置StoryboardID,设置为类名
    /// - returns: 类的实例变量
    public func instantiateVC<T>(_ identifier: T.Type = T.self) -> T {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        }
        fatalError("can not load nib view controller of \(identifier)")
    }
    
}
