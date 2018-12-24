//
//  NumberMorphViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/24.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import NumberMorphView

class NumberMorphViewController: UIViewController {

    @IBOutlet weak var displayTime: NumberMorphView!
    override func viewDidLoad() {
        super.viewDidLoad()

        displayTime?.currentDigit = 1
        displayTime?.animationDuration = 1
        var i = 1
        DispatchQueue.global().async {
            while i < 10 {
                DispatchQueue.main.async {
                    self.displayTime?.nextDigit = i
                }
                sleep(1)
                i+=1
                if i == 10 {
                    i = 0
                }
            }
        }
        
        // Do any additional setup after loading the view.
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
