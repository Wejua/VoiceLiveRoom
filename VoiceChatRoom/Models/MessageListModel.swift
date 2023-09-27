//
//  MessageListModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/1.
//

import SwiftUI

struct MessageListModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var list: [MessageModel]

        struct MessageModel: Codable {
            var icon: String //头像
            var nickName: String //昵称
            var topPrivilege: Bool //置顶特权
            var uid: Int
            var vip: VipModel
            
            struct VipModel: Codable {
                var isBlack: Bool //是否为黑金会员
                var isVip: Int
                var vipIcon: String
                var vipMemberTip: String //会员特权描述
                var vipPrivilegeNum: Int //拥有特权数量
                var vipStars: Int
                var vipTitile: String //特权描述(免费通话)
            }
        }
    }
}

struct MomentsListModel: Codable {
    var data: [MomentModel]
    
    struct MomentModel: Codable {
        var voice: String?
        var isLike: Bool
        var visibleType: Int
        var pv: Int
        var isSayHello: Bool
        var likeCount: Int
        var video: String?
        var content: String
        var isAuth: Bool
        var officialIcon: String?
        var userLevel: Int
        var top: Bool
        var timeDesc: String
//        var contentLink:{}
        var id: String
        var vip: VipModel
        var isCalling: Bool
        var height: Int
//        var area
        var likeUrls: [String]
        var image: [String]
        var nickName: String
        var sex: String
        var avatar: String
        var label: Int
        var follow: Bool
        var userId: Int
        var commentCount: Int
        var topicId: Int
        var width: Int
        var topicName: String
        var time: String
        var realPerson: Bool
        var platformTop: Bool
        var age: Int
        var chatRoom: ChatRoomModel
        var lookCount: Int 
        
        struct ChatRoomModel: Codable {
            var roomAccid: Int
            var name: String?
            var iconUrl: String?
            var id: Int
            var type: Int
            var liveBroadcast: Bool
        }
        
        struct VipModel: Codable {
            var vipPrivilegeNum: Int
            var isBlack: Bool
            var vipTitile: String?
            var vipMemberTip: String?
            var vipStars: Int
            var isVip: Int
            var vipIcon: String
        }
    }
}
