//
//  HospitalView.swift
//  EasyApp
//
//  Created by 王雄皓 on 16/9/22.
//  Copyright © 2016年 王雄皓. All rights reserved.
//

import UIKit

class HoRouter {
    
    static func present<T>(_ cls: T.Type, params: [String: Any]? = nil) {
        
        HoRouter.p(cls, params: params, isPush: false)
    }
    
    static func push<T>(_ cls: T.Type, params: [String: Any]? = nil, pushed hidden: Bool = true) {
        
        HoRouter.p(cls, params: params, pushed: hidden)
    }
    
    // 获取pushed控制器
    static func pushedController<T>(_ classType: T.Type) -> UIViewController? {
        
        let clsName = String(describing: classType)

        var headerCls = ""
        var pushedController: UIViewController!
        if let info = Bundle.main.infoDictionary {
            if let h = info["CFBundleExecutable"] as? String {
                headerCls = h + "." + clsName
            }
        }
        
        if let anyClass: AnyClass = NSClassFromString(headerCls) {
            
            if let viewControllerClass: UIViewController.Type = anyClass as? UIViewController.Type {
                
                pushedController = viewControllerClass.init()
                return pushedController
            }
            else {
                print("\(clsName): 没有找到这个类相关的类")
            }
        }
        
        return nil
    }
    
    // 获取当前控制器
    static func topViewController() -> UIViewController? {
        
        return self.topViewController(withRootViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
}
// 私有方法
fileprivate extension HoRouter {
    
    // push or present 方式弹出
    static func p<T>(_ classType: T.Type = T.self, params: [String: Any]? = nil, isPush: Bool = true, pushed hidden: Bool = false) {
     
        let clsName = String(describing: classType)
        
        var headerCls = ""
        var pushedController: UIViewController!
        var result: [String]!
        if let info = Bundle.main.infoDictionary {
            
            if let h = info["CFBundleExecutable"] as? String {
                var newHeaderCls = h
                if h.contains("-") {
                    newHeaderCls = h.replacingOccurrences(of: "-", with: "_")
                }
                headerCls = newHeaderCls + "." + clsName
            }
        }
        
        if let anyClass = NSClassFromString(headerCls) {
            
            result = HoRouter.getAllPropertys(forClass: anyClass)
            if let viewControllerClass: UIViewController.Type = anyClass as? UIViewController.Type {
                
                pushedController = viewControllerClass.init()
                if let currentController = topViewController() {
                    
                    if isPush {
                        currentController.navigationController?.pushViewController(pushedController, animated: true)
                    }
                    else {
                        currentController.present(pushedController, animated: true)
                    }
                }
            }
            else {
                print("\(clsName): 没有找到这个类相关的类")
            }
        }
        
        if let p = params {
            
            if result == nil { return }
            if pushedController == nil { return }
            
            for vk in p {
                
                if result.contains(vk.key) {
                    pushedController.setValue(vk.value, forKey: vk.key)
                }
                    
                else {
                    print("\(headerCls) 没有\(vk.key)此key")
                }
            }
        }
    }
    
    
    
    
    static func topViewController(withRootViewController: UIViewController?) -> UIViewController? {
        
        guard let rootViewController = withRootViewController else {
            return nil
        }
        
        if rootViewController.isKind(of: UITabBarController.classForCoder()) {
            
            if let tabBarController = rootViewController as? UITabBarController {
                return self.topViewController(withRootViewController: tabBarController.selectedViewController)
            }
        }
            
        else if rootViewController.isKind(of: UINavigationController.classForCoder()) {
            
            if let navigationController = rootViewController as? UINavigationController {
                return self.topViewController(withRootViewController: navigationController.visibleViewController)
            }
        }
            
        else if rootViewController.presentedViewController != nil {
            
            return self.topViewController(withRootViewController: rootViewController.presentedViewController)
        }
            
        else {
            return rootViewController
        }
        
        return nil
    }
    
    /**
     获取对象的所有属性名称
     
     - returns: 属性名称数组
     */
    static func getAllPropertys(forClass: AnyClass) -> [String] {
        
        var result = [String]()
        var count: UInt32 = 0
        //1.获取类的属性列表,返回属性列表的数组,可选项
        let list = class_copyPropertyList(forClass, &count)
        
        for i in 0..<Int(count) {
            //使用guard语法,一次判断每一项是否有值,只要有一项为nil,就不再执行后续的代码
            guard let pty = list?[i],
                let name = String(utf8String: property_getName(pty))
                else {
                    //继续遍历下一个
                    continue
            }
            result.append(name)
        }
        free(list)
        return result
    }

}

