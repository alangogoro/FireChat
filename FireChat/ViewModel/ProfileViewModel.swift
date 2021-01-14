//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by usr on 2020/12/28.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo = 0
    case settings = 1
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
    
}
