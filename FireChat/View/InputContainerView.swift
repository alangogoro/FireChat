//
//  InputContainerView.swift
//  FireChat
//
//  Created by usr on 2020/12/8.
//

import UIKit

class InputContainerView: UIView {
    
    init(image: UIImage?, textField: UITextField) {
        /* ❗️⭐️ 仍須呼叫預設建構式，不過尺寸大小先設0 ⭐️❗️ */
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.85
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 24, width: 24)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingLeft: 8, paddingBottom: -8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                           paddingLeft: 8,
                           height: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
