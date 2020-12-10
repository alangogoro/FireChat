//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/10.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    /** 計算屬性
     * Email、密碼、姓名、用戶名皆非空值時回傳 true */
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
    }
}

