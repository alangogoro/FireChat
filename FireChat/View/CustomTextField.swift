//
//  CustomTextField.swift
//  FireChat
//
//  Created by usr on 2020/12/8.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        /* ⚠️ 仍須呼叫預設建構式，不過尺寸大小先設0 */
        super.init(frame: .zero)
        
        // 去除邊框
        borderStyle = .none
        // 文字大小
        font = UIFont.systemFont(ofSize: 16)
        // 文字顏色
        textColor = .white
        // 鍵盤樣式：黑暗模式
        keyboardAppearance = .dark
        /* 客製化提示文字
         * 讓提示文字呈現白色 */
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor: UIColor.white])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
