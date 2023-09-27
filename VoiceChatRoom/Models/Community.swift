//
//  Community.swift
//  VoiceChatRoom
//
//  Created by ByteDance on 2023/8/31.
//

import Foundation

class CommunityHomeModel: Codable, ObservableObject {
    var avatarUrl: String?
    var name: String?
    var gender: Int?
    var momentTime: Int?
    var follow: Bool?
    var id: String
    var isLike: Bool?
    var isVip: Bool?
    
}
