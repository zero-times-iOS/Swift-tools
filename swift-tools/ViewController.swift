//
//  ViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibView = HoNib.instantiateView(NibView.self)
        nibView.frame = self.view.frame
        self.view.addSubview(nibView)
    
    
        // Do any additional setup after loading the view, typically from a nib.
    }


}

