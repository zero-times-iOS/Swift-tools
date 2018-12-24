//
//  MView.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/24.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import Macaw

class MView: MacawView {

    required init?(coder aDecoder: NSCoder) {
        let shape = Shape(form: Rect(x: 10, y: 10, w: 175, h: 30),
                          fill: Color(val: 0xfcc07c),
                          stroke: Stroke(fill: Color(val: 0xff9e4f), width: 2))
        super.init(node: shape, coder: aDecoder)
    }
}
