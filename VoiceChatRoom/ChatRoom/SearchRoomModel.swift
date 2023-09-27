//
//  SearchRoomModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/29.
//

import Foundation

struct SearchRoomModel: Codable {
    var data: [ItemModel]
    
    struct ItemModel: Codable {
        var compereNickName: String
        var roomLevelIcon: String
        var roomStatus: Int
        var roomIcon: String
        var shineId: Int
        var roomName: String
        var roomId: Int
    }
}
