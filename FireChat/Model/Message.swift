//
//  Message.swift
//  FireChat
//
//  Created by usr on 2020/12/22.
//

import Firebase

struct Message {
    let text: String
    let fromId: String
    let toId: String
    var timestamp: Timestamp!
    var user: User?
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        // 在聊天室中要判斷留言的方向性（發送or接收）
        // 用一個會按照 Id 決定的 Bool 來儲存此資訊
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
}
