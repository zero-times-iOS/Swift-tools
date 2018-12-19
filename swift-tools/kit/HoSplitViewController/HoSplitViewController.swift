//
//  HoSplitViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class HoSegue: UIStoryboardSegue {
    override func perform() { }
}

enum HoSplitType: Int {
    case left  = 0 /// 必须设置Identifier left and master
    case right     /// 必须设置Identifier right and master
    case both      /// 必须设置Identifier left,right and master
}

class HoSplitViewController: UIViewController {

    /// 控制器push出最大宽度
    @IBInspectable var pushMaxWidth: CGFloat = 200 {
        didSet {
            updateUI()
        }
    }
    
    /// 默认从storyboard加载
    var loadFromStoryboard = true
    
    /// 动画时间
    @IBInspectable var duration: TimeInterval = 0.25
    
    /// 加载方式
    @IBInspectable var type: Int = HoSplitType.left.rawValue
    
    /// 主视图控制器
    var masterViewController: UIViewController! {
        didSet {
            updateUI()
        }
    }
    
    /// 左视图控制器
    var leftViewController: UIViewController! {
        didSet {
            updateUI()
        }
    }
    
    /// 右视图控制器
    var rightViewController: UIViewController! {
        didSet {
            updateUI()
        }
    }
    
    /// 标识
    fileprivate struct Identifier {
        /// 主视图标识
        static let master = "Ho Master"
        /// 左视图标识
        static let left   = "Ho Left"
        /// 右视图标识
        static let right  = "Ho Right"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        if loadFromStoryboard {
            
            var identfiers = [Identifier.master]
            if let type = HoSplitType.init(rawValue: type) {
                
                switch type {
                case .left:
                    identfiers.append(Identifier.left)
                case .right:
                    identfiers.append(Identifier.right)
                case .both:
                    identfiers.append(Identifier.left)
                    identfiers.append(Identifier.right)
                }
            }
            else {
                fatalError("not have HoSplitType of \(type)")
            }
            
            _ = identfiers.map {
                self.performSegue(withIdentifier: $0, sender: nil)
            }
        }
    }
    
    /// 更新界面
    fileprivate func updateUI() {
        
        _ = [leftViewController, masterViewController, rightViewController].map {
            if let vc = $0 {
                if !self.view.subviews.contains(vc.view) {
                    self.view.addSubview(vc.view)
                }
                if !self.children.contains(vc) {
                    self.addChild(vc)
                }
            }
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        leftViewController?.view.transform  = CGAffineTransform(translationX: -pushMaxWidth, y: 0)
        leftViewController?.view.frame.size.width = pushMaxWidth
        leftViewController?.view.layoutIfNeeded()

        rightViewController?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
        rightViewController?.view.frame.size.width = pushMaxWidth
        rightViewController?.view.layoutIfNeeded()
        
        if visibleViewController != nil {
            addScreenEdgePanGestureRecognizerTo(view: visibleViewController.view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        let identifier = segue.identifier
        
        if identifier == Identifier.master {
            masterViewController = vc
        }
        else if identifier == Identifier.left {
            leftViewController   = vc
        }
        else if identifier == Identifier.right {
            rightViewController  = vc
        }
        
        updateUI()
    }
    
    /// 侧边栏跳转1
    func performSegue(_ identifier: String, sender: Any?) {
        
        visibleViewController?.performSegue(withIdentifier: identifier, sender: sender)
        closeLeftMenu()
    }
    
    /// 侧边栏跳转2
    func leftViewControllerPush(_ controller: UIViewController) {
        
        var nav: UINavigationController?
        if let tabbarVC = masterViewController as? UITabBarController {
            nav = tabbarVC.selectedViewController as? UINavigationController
            controller.hidesBottomBarWhenPushed = true
        }
        else if let viewController = masterViewController.navigationController {
            nav = viewController
        }
        else {
            nav = masterViewController as? UINavigationController
        }
        
        if nav == nil {
            masterViewController.present(controller, animated: true)
        }
        else {
            nav?.pushViewController(controller, animated: true)
        }
        closeLeftMenu()
    }
    
    /// return主视图控制器
    fileprivate var visibleViewController: UIViewController! {
        
        var sourcesVC: UIViewController!
        
        if let tabbarVC = masterViewController as? UITabBarController {
            sourcesVC = tabbarVC.selectedViewController as? UINavigationController ?? tabbarVC.selectedViewController
        }
        else if let nav = masterViewController as? UINavigationController {
            sourcesVC = nav.visibleViewController
        }
        else {
            sourcesVC = masterViewController
        }
        
        return sourcesVC
    }

    /// 添加屏幕边缘手势
    fileprivate func addScreenEdgePanGestureRecognizerTo(view: UIView) {
        
        if view.gestureRecognizers == nil {
            
            let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgPanGesture(_:)))
            if view.gestureRecognizers != nil {
                if view.gestureRecognizers!.contains(pan) {
                    return
                }
            }
            
            pan.edges = UIRectEdge.left.union(UIRectEdge.right)
            view.addGestureRecognizer(pan)
        }
    }
    
    /// 屏幕手势
    @objc fileprivate func edgPanGesture(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        let screenWidth = UIScreen.main.bounds.size.width
        print(offsetX)
        if pan.state == UIGestureRecognizer.State.changed && offsetX <= pushMaxWidth {
            
            masterViewController?.view.transform = CGAffineTransform(translationX: max(offsetX, 0), y: 0)
            leftViewController?.view.transform = CGAffineTransform(translationX: -pushMaxWidth + offsetX, y: 0)
        }
        else if pan.state == UIGestureRecognizer.State.ended || pan.state == UIGestureRecognizer.State.cancelled || pan.state == UIGestureRecognizer.State.failed {
            
            if offsetX > screenWidth * 0.5 {
                openLeftMenu()
            }
            else {
                closeLeftMenu()
            }
        }
    }
    
    /// 打开左视图
    func openLeftMenu() {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.leftViewController?.view.transform   = CGAffineTransform.identity
            self.masterViewController?.view.transform = CGAffineTransform(translationX: self.pushMaxWidth, y: 0)
        }) { _ in
            self.masterViewController?.view.addSubview(self.rightConverButton)
        }
    }
    
    /// 关闭左视图
    @objc func closeLeftMenu() {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.leftViewController?.view.transform  = CGAffineTransform(translationX: -self.pushMaxWidth, y: 0)
            self.masterViewController?.view.transform = CGAffineTransform.identity
        }) { _ in
            self.rightConverButton.removeFromSuperview()
        }
    }
    
    /// 打开右视图
    func openRightMenu() {
        let screenWidth = UIScreen.main.bounds.size.width
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.rightViewController?.view.transform  = CGAffineTransform(translationX: screenWidth-self.pushMaxWidth, y: 0)
            self.masterViewController?.view.transform = CGAffineTransform(translationX: -self.pushMaxWidth, y: 0)
        }) { _ in
            self.masterViewController?.view.addSubview(self.leftConverButton)
        }
    }
    
    /// 关闭右视图
    @objc func closeRightMenu() {
        let screenWidth = UIScreen.main.bounds.size.width
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.rightViewController?.view.transform  = CGAffineTransform(translationX: screenWidth, y: 0)
            self.masterViewController?.view.transform = CGAffineTransform.identity
        }) { _ in
            self.leftConverButton.removeFromSuperview()
        }
    }
    
    /// 灰色背景按钮
    fileprivate lazy var leftConverButton: UIButton = {
        
        let btn = UIButton(frame: self.masterViewController!.view.bounds)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(closeRightMenu), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    /// 灰色背景按钮
    fileprivate lazy var rightConverButton: UIButton = {
       
        let btn = UIButton(frame: self.masterViewController!.view.bounds)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(closeLeftMenu), for: UIControl.Event.touchUpInside)
        btn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCloseMenu(_:))))
        return btn
    }()
    
    /// 遮盖按钮手势
    @objc fileprivate func panCloseMenu(_ pan: UIPanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        if offsetX > 0 {
            return
        }
        
        let screenWidth = UIScreen.main.bounds.size.width

        if pan.state == UIGestureRecognizer.State.changed && offsetX >= -pushMaxWidth {
            
            let distace = pushMaxWidth + offsetX
            
            masterViewController?.view.transform = CGAffineTransform(translationX: distace, y: 0)
            leftViewController?.view.transform   = CGAffineTransform(translationX: offsetX, y: 0)
        }
        else if pan.state == UIGestureRecognizer.State.ended || pan.state == UIGestureRecognizer.State.cancelled || pan.state == UIGestureRecognizer.State.failed {
            
            if offsetX > -screenWidth * 0.5 {
                openLeftMenu()
            }
            else {
                closeLeftMenu()
            }
            
        }
    }
}
extension UIViewController {
    
    /// 获取侧滑主控制器
    ///
    /// - returns: HoSplitViewController实例
    func splitVC() -> HoSplitViewController? {
        
        var newParent = parent
        if parent != nil {
            if let nav = parent as? UINavigationController {
                newParent = nav.parent
            }
            while !newParent!.isKind(of: HoSplitViewController.classForCoder()) {}
        }
        
        return newParent as? HoSplitViewController
    }
}
