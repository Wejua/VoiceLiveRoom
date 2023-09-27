//
//  SearchUserModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/30.
//

import SwiftUI

struct SearchUserModel: Codable {
    var data: [SearchUserDataModel]
    
    struct SearchUserDataModel: Codable {
        var age: Int
        var avatar: String
        var birthyear: Int
        var charmGrade: Int
        var gender: Gender
        var isFriend: Int
        var isNobleShineId: Int
        var roomId: Int
        var shineUid: Int
        var uid: Int
        var userName: String
        var vip: Bool
    }
}
