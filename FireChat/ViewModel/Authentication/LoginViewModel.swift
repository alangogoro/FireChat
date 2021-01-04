//
//  LoginViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/9.
//

import Foundation

/* 由於有多個結構，都需要一個判斷使用者資料是否填寫完整的 Bool
 * 可以寫成一個協定，限定 get */
protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    /** 計算屬性
     * Email 和 密碼是皆非空值時回傳 true */
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
