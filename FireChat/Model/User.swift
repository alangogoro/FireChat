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
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
