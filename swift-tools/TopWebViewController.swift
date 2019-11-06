//
//  TopWebViewController.swift
//  swift-tools
//
//  Created by HOA on 2019/11/6.
//  Copyright © 2019 Hoa. All rights reserved.
//

import UIKit

class TopWebViewController: HoHeaderWebViewController {

    override func viewDidLoad() {
        topViewHeight = 300
        super.viewDidLoad()

        url = "https://aiwanwang.cn"
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        btn.setTitle("黑", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rr), for: .touchUpInside)
        topView.addSubview(btn)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(rr))
        topView.addGestureRecognizer(tapGes)
        
        topView.superview?.bringSubviewToFront(topView)
        
    }
    
    @objc func rr() {
        print("白")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

