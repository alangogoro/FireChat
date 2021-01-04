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
    
    /// 聊天對象的 Uid
    var chatWithId: String {
        /* 聊天訊息內包含了 fromId & toId
         * 為了正確顯示聊天對象的名稱、大頭貼，而非使用者自己的
         * 在這裡需要排除掉使用者自身，取得對方的 Id */
        return isFromCurrentUser ? toId : fromId
    }
}

struct Conversation {
    let user: User
    let message: Message
}
