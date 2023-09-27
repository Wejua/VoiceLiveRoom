//
//  UserInfoModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/30.
//

import Foundation

struct UserInfoModel: Codable {
    var data: UserInfoDataModel
    
    struct UserInfoDataModel: Codable {
        var basic: BasicModel
        var charmGrade: Int //魅力等级
        var richGrade: Int //财富等级
        var fansGroup: FansGroupModel?
        var gifts: [GiftsModel]?
        var grade: GradeModel?
        var `guard`: GuardModel?
        var relationCount: RelationCountModel
        var risk: Bool //是否存在风险
        var seiyuu: Bool //是否声优
        var sendFreeU: Bool //是否可领取免费U币
        var status: Int //状态,-1：不展示 0: 在线，1: 语音中 2:视频中 3:聊天室中
    }
    
    struct BasicModel: Codable {
        var address: String
        var age: Int
        var gender: Gender
        var slogan: String //个人简介
        var sloganStatus: Int //个人简介状态
        var userId: Int
        var userLevel: Int
        var userName: String //昵称
        var banRights: Int //封号权限，0：没有，1：风纪委员，2：管理员
        var birthDay: String //生日
        var bwh: String
        var city: String
        var completion: Int // 资料完成度
        var currentAvatar: String //当前展示的头像
        var currentNickName: String //当前展示的昵称
        var defaultAddress: String //根据ip获取默认地址
        var dynamicNobleIcon: String? //爵位头衔动态图片
        var education: String // 学历
        var emotion: String //情感
        var goodId: Int //靓号
        var height: Int// 身高(cm)
        var horoscope: String //星座
        var latestTime: Int //最近在线时间
        var latestTimeDesc: String //最近在线时间
        var loginRealPerson: Bool //登录用户是否真人，true 是， false 否
        var nobleIcon: String? //爵位头衔图片
        var noblePrivilegeNum: String //爵位含有特权数
        var nobleShineId: Bool //是否是贵族靓号 true-是 false-否
        var nobleTitle: String? //爵位头衔
        var occupation: String //职业
        var officialIdentifyIcon: String? //官方认证图标，没有则为空
        var officialIdentifyIconList: [String]? //官方认证图标列表，没有则为空
        var portraitStatus: Int //头像状态
        var portraitUrl: String // 头像
        var province: String //归属地省
        var realPerson: Bool //是否真人，true 是， false 否
        var registerTime: Int //注册时长，天
        var revenue: String  // 年收入
        var showGiftWall: Bool //是否显示礼物墙
        var topPrivilegeInfo: TopPrivilegeInfoModel
    }
    
    struct TopPrivilegeInfoModel: Codable {
        var fontColor: String? //字体颜色
        var sendBackdrop: String? //    背景图片
        var receiveBackdrop: String? //    背景图片
        var topPrivilege: Bool //置顶特权 true-拥有 false-未拥有
    }
    
    struct RelationCountModel: Codable {
        var fansNum: Int //粉丝数
        var charmNum: Int //魅力值
        var increasedVisitorNum: Int //新增访客数
        var friendsNum: Int //好友数
        var increasedFansNum: Int //新增粉丝数
        var richNum: Int //土豪值
        var visitorNum: Int //访客数
        var followsNum: Int //关注数
    }
    
    ///粉丝团
    struct FansGroupModel: Codable {
        var fansCount: Int
        var id: Int
        var name: String
        var topFensAvatars: [String] //粉丝团前三的头像数组
    }
    
    struct GiftsModel: Codable {
        var charm: Int //礼物魅力值
        var icon: String //礼物图标
        var name: String //礼物名称
        var num: Int //礼物数量
        var unit: String //礼物数量单位
    }
    
    struct GradeModel: Codable {
        var color: String //颜色
        var iconUrl: String
        var name: String //等级名称
        var nextIconUrl: String //下一等级图标
        var point: Int //当前经验值，积分点
        var rank: Int //等级
        var uid: Int?
    }
    
    struct GuardModel: Codable {
        var diamondToGuardRate: Float //守护值兑换钻石数
        var guardDiamonNum: Float //守护值兑换钻石数
        var guardNum: Int
        var guardTime: Int
        var guardUid: Int
        var portraitUrl: String
    }
}
