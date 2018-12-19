//
//  HoLimitLengthUITextField.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class HoLimitLengthTextField: UITextField {
    
    /// @IBInspectable 声明：可在关联storyboard or xib中设置值
    @IBInspectable var maxLength: Int = 10
    
    init(frame: CGRect, maxLength: Int = 10) {
        super.init(frame: frame)
        self.maxLength = maxLength
        addTarget(self, action: #selector(textFieldEditingChange), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(textFieldEditingChange), for: UIControl.Event.editingChanged)
    }
    
    /// 值发生改变
    @objc fileprivate func textFieldEditingChange() {
        
        if let text = self.text {
         
            let temp = NSString(string: text)
            let Chinese = "zh-Hans"
            let language = textInputMode?.primaryLanguage
            
            if language == Chinese {
                let range = markedTextRange
                if range == nil {
                    if text.count >= maxLength {
                        self.text = temp.substring(to: maxLength)
                    }
                }
            }
            else {
                if text.count >= maxLength {
                    self.text = temp.substring(to: maxLength)
                }
            }
        }
    }
    
}
