//
//  MessageViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/22.
//

import UIKit

struct MessageViewModel {
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? .lightGray : .systemPurple
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    init(message: Message) {
        self.message = message
    }
}
