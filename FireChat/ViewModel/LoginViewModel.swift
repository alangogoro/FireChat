//
//  LoginViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/9.
//

import Foundation

struct LoginViewModel {
    var email: String?
    var password: String?
    
    /** 計算屬性
     * Email 和 密碼是皆不為空值時是 true */
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
