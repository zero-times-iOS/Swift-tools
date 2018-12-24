//
//  StarWarsViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/24.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class StarWarsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibView = NibView.nibView
        nibView.frame = self.view.frame
        nibView.backgroundColor = UIColor.random
        self.view.addSubview(nibView)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func close() {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

}
