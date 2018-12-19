//
//  NibView.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class NibView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var displayTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayTitle.textColor = UIColor.random
        displayTitle.backgroundColor = UIColor("0xFFFFFF")
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                self.displayTitle.textColor = UIColor.random
                self.displayTitle.setText("Swift Tools")
            }
        }
    }
}
