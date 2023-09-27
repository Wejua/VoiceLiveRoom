//
//  File.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/30.
//

import Foundation

struct RoomViewersModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        /// 全部人数
        var totalNum: Int
        var userList: [User]
    }
    
    struct User: Codable {
        var avatar: String
        var counts: Int //人气值
        var uid: Int
    }
}


class IsFollowModel: Codable, ObservableObject {
    var data: DataModel
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(IsFollowModel.DataModel.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.data, forKey: .data)
    }
    
    class DataModel: Codable, ObservableObject {
        
        var isFollow: Int
        var isMyFans: Int
        
        func encode(to encoder: Encoder) throws {
            var container: KeyedEncodingContainer<IsFollowModel.DataModel.CodingKeys> = encoder.container(keyedBy: IsFollowModel.DataModel.CodingKeys.self)
            try container.encode(self.isFollow, forKey: IsFollowModel.DataModel.CodingKeys.isFollow)
            try container.encode(self.isMyFans, forKey: IsFollowModel.DataModel.CodingKeys.isMyFans)
        }
        
        enum CodingKeys: CodingKey {
            case isFollow
            case isMyFans
        }
        
        required init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<IsFollowModel.DataModel.CodingKeys> = try decoder.container(keyedBy: IsFollowModel.DataModel.CodingKeys.self)
            self.isFollow = try container.decode(Int.self, forKey: IsFollowModel.DataModel.CodingKeys.isFollow)
            self.isMyFans = try container.decode(Int.self, forKey: IsFollowModel.DataModel.CodingKeys.isMyFans)
        }
    }
}

struct UserGradeInfoModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var charmGrade: Int //财富等级
        var charmIcon: String //魅力等级图标
        var heartbeats: Int //被心动值
        var richesGrade: Int //财富等级
        var richesIcon: String //财富等级图标
        var roomMedalGrade: Int //房间勋章等级
        var roomMedalIcon: String //房间勋章图标
        var roomMedalTitle: String //房间勋章等级称号
    }
}

//struct AttentionModel: Codable {
//    var content: String //例： "关注成功后，短期内无法取消关注",
//    var status: Int
//}

struct AttentionListModel: Codable {
    var data: [FriendsListModel.DataModel]
}

struct FriendsListModel: Codable {
    var data: [DataModel]
    
    struct DataModel: Codable {
        var age: Int
        var avatar: String
        var chatRoom: ChatRoomModel
        var gender: Gender
        var intimateNum: Int //亲密值
        var isFans: Bool //是否互粉
        var lastTime: String //用户最近在线时间
        var levelIcon: String //用户勋章
        var nobleDynamicImage: String //贵族图标
        var slogan: String //个性签名
        var uidRel: Int //用户ID
        var username: String //用户名
        var vip: [VipModel]
        
        struct VipModel: Codable {
            var isBlack: Bool //是否是黑金会员
            var isVip: Int
            var vipIcon: String
            var vipMemberTip: String //会员特权描述
            var vipPrivilegeNum: Int //拥有特权数量
            var vipStars: Int
            var vipTitile: String //特权描述(免费通话)
        }
        
        struct ChatRoomModel: Codable {
            var iconUrl: String
            var id: Int
            var liveBroadcast: Bool //直播间 true-是直播间 false-不是
            var name: String //聊天室名称
            var roomAccid: Int //房间创建者ID
            var type: Int //房间类型
            var uid: Int
            
        }
    }
}

struct FansListModel: Codable {
    var data: [FriendsListModel.DataModel]
}


struct RoomMembersModel: Codable {
    var data: [MemberModel]
    
    struct MemberModel: Codable {
        var age: Int?
        var avatar: String?
        var contributionValue: Int?
        var gagFlag: Bool? //是否被禁言
        var gender: Gender?
        var headWear: String? //头饰
        var level: Int? //用户等级
        var nickName: String?
        var nobleDynamicImage: String? //贵族标签以及聊天室标签
        var seatId: Int? //座位ID
        var uid: Int
        var userType: Int? //用户在房间内的身份 0-普通 1-房主 2-管理 3-主持
        var vip: VipModel?
        
        struct VipModel: Codable {
            var isBlack: Bool?
            var stars: Int?
            var title: String? // vip等级名称
            var vipIcon: String?
            var vipMemberTip: String?
            var vipType: Int? //vip等级名称 1-svip年会员， 2-svip月会员， 3-年vip, 4-vip月会员
        }
    }
}

struct OnOrOffSeatModel: Codable {
    var content: String?
    var data: DataModel?
    var status: Int?
    
    struct DataModel: Codable {
        
    }
}


struct RoomSeatInfoModel: Codable {
    var content: String?
    var data: [SeatModel]?
    
    struct SeatModel: Codable {
        var avatar: String?
        var closeSendMessage: Bool //默认false可以发公屏消息，true不能发
        var closeSpeak: Bool? //默认false可以发言，true不能发言
        var gameState: Int? //游戏准备状态: 0、未参加游戏 2、已准备 3、未准备 4、游戏中
        var grade: Int //1房主 2主持人 3管理员 4普通成员
        var hallucinationChangeUid: Int //分身施法人uid
        var headWear: String?
        var magicChangeEffectUrl: String? //魔法变变变特效url
        var magicChangeUid: Int //施法人uid
        var music: Bool?
        var seatBlocked: Bool //麦位是否被封 true-已被封，false-未被封
        var seatEffectUrl: String //座位特效
        var seatId: Int  //0-7普通位，8-主持位
        var startVoteFlag: Bool //true-已开启，false-已关闭
        var uid: Int? //为0就是没有人在麦上
        var username: String?
        var voteNum: Int?
    }
}
