//
//  GiftsListModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/1.
//

import SwiftUI

struct GiftsListModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var allGiftNum: Int //    礼物墙礼物总数
        var giftList: [GiftModel]? //
        var lightNum: Int //已点亮礼物数
        var showGiftWall: Bool //是否显示礼物墙
        
        struct GiftModel: Codable {
            var giftWallNum: Int //礼物点亮需要数量
            var have: Bool //是否获得
            var icon: String //礼物图标url
            var id: Int // 礼物id
            var name: String //礼物名称
            var num: Int //礼物数量
            var numInBack: Int //背包中的该礼物数量
            var sendByWall: Bool //是否能在礼物墙赠送
            var status: Int  //礼物是否可以赠送 0、可送 1、不可送
            var unit: String //礼物数量单位
            var worth: Float //礼物价值
            var worthUnit: Int //价值单位
            
        }
    }
}

struct BackpackGiftsModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var comboTime: Int
        var id: Int
        var name: String
        var list: [GiftModel]
        
        struct GiftModel: Codable {
            var canSendSelf: Bool //是否可自刷 true-可 false-不可
            var counts: Int
            var expireTime: String
            var gift: Int
            var icon: String
            var id: Int
            var name: String
            var path: String
            var pathType: Int //路径类型：1-svgaPath 2-gifPath 3-webpPath
            var tabId: Int
            var unit: String
            var voicePath: String
            var worth: Float
            var worthUnit: Int 
        }
    }
}

struct SendGiftModel: Codable {
    var data: DataModel
    var canRemoveMagic: Bool
    var canSendWall: Bool //是否上表白墙
    var heartNum: String //心动值
    var isSayu: Int //是否是声优 1-是 0-否
    var logId: Int
    var noWithdrawDiamond: String //不可提现钻石余额
    var remainDiamond: Float //做心动值之前返回的钻石余额
    var rewardInfo: RewardInfoModel
    
    struct RewardInfoModel: Codable {
        var coinDropUrl: String //金币掉落特效url
        var multiple: Int //倍数
        var rewardDiamondNum: Float //奖励钻石数
        var rewardEffectUrl: String //特效url，为空展示普通特效
    }

    
    struct DataModel: Codable {
        var airDropGifts: [AirDropGiftsModel]
        
        struct AirDropGiftsModel: Codable {
            var expireTime: String
            var giftIcon: String
            var giftName: String
            var rewardNum: Int
            var worth: Float
            
        }
    }
}

struct SeatsModel: Codable {
    var data: [DataModel]
    
    struct DataModel: Codable {
        var coverImage: String //道具封面
        var dynamicImage: String //svg
        var expire: Int //过期时间
        var id: Int //用户购买流水ID
        var propId: Int //道具ID
        var propName: String //道具名称
        var realizeEffectValue: Int //实现效果
        var status: Int //0未使用，1使用中，2已过期（根据expire计算出来）, 3已使用
    }
}
