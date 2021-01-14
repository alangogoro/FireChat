//
//  ConversationViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/27.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        /* ➡️ 取得時間戳記並轉換為日期字串 */
        let date = conversation.message.timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // 01:23 AM
        
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
