//
//  EasyAnimationViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/25.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import EasyAnimation

class EasyAnimationViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        EasyAnimation.enable()
        
        _ = UIView.animateAndChain(withDuration: 2.0, delay: 2.0, options: UIView.AnimationOptions.repeat.union(UIView.AnimationOptions.autoreverse.union(.curveEaseOut)), animations: {
            self.animationView.layer.position.y -= 300.0
            // let's add more animations
            // to make it more interesting!
            self.animationView.layer.cornerRadius = 20.0
            self.animationView.layer.borderWidth = 5.0
            self.animationView.backgroundColor = UIColor.random
        }, completion: nil)
    }
}
