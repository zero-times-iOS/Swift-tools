//
//  ViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEffect()
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}
fileprivate extension ViewController
{
 
    /// 添加运动效果
    func addEffect() {
        
        var motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffect.EffectType.tiltAlongHorizontalAxis)
        motionEffect.minimumRelativeValue = -25
        motionEffect.maximumRelativeValue = 25
        displayTitle?.addMotionEffect(motionEffect)
        
        motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffect.EffectType.tiltAlongVerticalAxis)
        motionEffect.minimumRelativeValue = -25
        motionEffect.maximumRelativeValue = 25
        displayTitle?.addMotionEffect(motionEffect)
    }
}

