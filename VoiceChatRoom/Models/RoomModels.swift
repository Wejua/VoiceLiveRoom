//
//  RoomModels.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/6.
//

import Foundation

struct MyRoomModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var ifCertified: Bool? //是否实名认证
        var myRoom: RoomModel?
        var reviewList: [ReviewModel]? //头像，房间名称，公告的审核记录
        var studio: RoomModel?
        
        struct ReviewModel: Codable {
            var message: String?
            var status: Int //-1失败 0-审核中 1-成功
            var type: Int
            var url: String?
        }
        
        struct RoomModel: Codable {
            var compereUserName: String? //主持人昵称，为空说明没有
            var gradeInfo: GradeModel?
            var heatPower: Int? //热力值
            var icon: String? //房间icon
            var id: Int //房间主键
            var label: LabelModel?
            var numberOfPeople: Int? //房间人数
            var roomId: Int? //房间id
            var roomType: Int? //房间类型
            var shineId: Int? //房间靓号
            var tag: String?
            var title: String?
            var uid: Int
            var userName: String
            
            
            struct LabelModel: Codable {
                var name: String
                var typeId: Int
            }
            
            struct GradeModel: Codable {
                var icon: String?
                var label: String?
            }
        }
    }
}

struct EnterRoomModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var advIds: String? //广告id
        var agoraToken: String? //声网token
//        var airdropOpenFlag: ?
        var announcement: String? //聊天室公告
        var auctionAdvUrl: String? // 拍卖行广告url
        var autoConnectSeat: Int? //是否自动连接麦位  0-否 1-是
        var background: String? //背景图片
        var backgroundForGif: String? //GIF背景图片
        var bannerId: String? //进入房间bannerIds
        var boxIntegral: Int? //宝箱积分
        var boxText: String? //宝箱文案
        var chatAirUrl: String? //聊天气泡图片
        var color: String? //用户公屏字体颜色
//        var  colorfulFont: //炫彩字体
        var compereInfo: CompereInfoModel?
        var enterRoomRedbagConfig: RedbagConfigModel?
        var enterUserId: Int? //进入房间用户ID
        var firstEnter: Bool? //是否第一次进来 true-是 false-否
        var freeWaggleConfig: FreeWaggleConfigModel?
        var gagFlag: Bool? //是否被禁言 true-是 false-否
        var gameId: Int? // 游戏Id
        var gameType: Int? // 房间游戏类型 1、五子棋 2、台球
        var gameVersion: String? //游戏版本
        var giftEffectShow: Int? // 礼物特效显示：-1：不显示，0：显示所有，500：显示500钻以上
        var hasEnchanted: Bool? //是否被施法 true-是
        var hasHallucinationAuthority: Bool? //是否有幻影分身权限 true-有
        var hasHallucinationEnchanted: Bool? // 是否被幻影分身
        var hasMagicAuthority: Bool? //是否有魔法权限 true-有
        var icon: String? //房间图标
        var inGameWd: Bool? //房间是否在谁是卧底游戏中
        var isFavorited: Bool? //是否收藏当前房间 0-否 1-是
        var isFirstEnterRoom: Int? //是否第一次进来 1-是 0-否
        var isNoble: Int? //是否是爵位
        var isSpeak: Int? //贵族是否防止被禁言0-否 1-是
        var ktvWaitTime: Int? //ktv房间切歌等待时长
        var loadType: Int? // loadType  0: 默认链接加载   1：加载本地html资源
        var maxHornNum: Int? //可发喇叭数量
        var mounts: MountsModel?
        var nobleAdvUrl: String? //爵位广告url
        var nobleDynamicImage: String? //爵位图标
        var onSeatQueue: Int? //0-未排队 1-女神位 2-老板位
        var openGame: Int? // 是否直接开始游戏 1、是
        var playModeType: Int? //房间玩法 3、KTV
        var popularity: Int? // 人气值
        var privilegeList: [Int]? //特权列表 王座1、移行换位2、模仿发言3、私聊置顶4
        var propMallUrl: String? //道具商城
        var roleIcon: String? //勋章
        var roomHostAvatar: String? //房主昵称
        var roomHostNickName: String? //房主昵称
        var roomHostUid: Int? //房主uid
        var roomIcon: String? //聊天室勋章
        var roomId: Int? //房间id
        var roomName: String? //房间名称
        var roomStatus: Int? //房间状态0-不关闭 1-关闭 2-设置密码
        var roomType: Int? //房间类型
        var sayuState: Bool? //是否是声优
        var seatNum: Int? //房型-麦上人数
        var sendMsgTaskNum: Int? //聊天室发公屏消息任务-限定条数
        var sendNewUserGiftTip: String? //赠送新用户聊天室礼物-文案
        var share: String? // 聊天室分享链接
        var shineId: Int? //房间靓号
        var sourceUrl: String? //资源地址
        var speakLimits: Int? //发言权限 0-所有人 1-房主和管理员 2-全体禁言
        var sportSongNum: Int? //每人点歌上限 默认 5
        var stealth: Bool? //
        var systempMsg: String? //系统公告
        var turnUrl: String? // 转盘链接
        var userLevel: Int? //用户等级
        var userType: Int? //用户在房间内的身份 0-普通 1-房主 2-管理
        var voteStatus: Int? //投票 1-开始 2-已结束
        
        struct MountsModel: Codable {
            var message: String?
            var svgaConfig: String?
            var type: String?
            var url: String?
        }
        
        struct FreeWaggleConfigModel: Codable {
            var imgUrl: String? //免费抽奖卷
            var springWasher: Int? //弹窗延迟时间
            var url: String? // 跳转地址
        }
        
        struct RedbagConfigModel: Codable {
            var amount: Float? //金额
            var capContent: String? //点击后内容
            var capTitler: String? //点击后标题
            var content: String? //内容
            var getTime: Int? //领取时间
            var springWasher: Int? //弹窗延迟时间
            var titler: String? //标题
            var token: String? //token,手动领取时需传入
        }
        
        struct CompereInfoModel: Codable {
            var avatar: String?
            var nickName: String?
            var uid: Int?
        }
        
    }
}
