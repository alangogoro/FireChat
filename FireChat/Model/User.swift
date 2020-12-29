//
//  User.swift
//  FireChat
//
//  Created by usr on 2020/12/18.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    
    /* 🔰➡️ 建構式
     * 傳入 Dictionary 即會生成 user 物件
     * Any 資料無法轉型為字串時，會預設為 "" 空字串避免 nil */
    init(dictionary: [String: Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
