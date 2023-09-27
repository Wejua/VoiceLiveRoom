//
//  BasicInfoModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/6/16.
//

import Foundation
import SwiftUI

struct BasicInfoModel: Codable {
    var portraitUrl: String? //头像
    var userName: String? //名字
    var userId: Int //uid
    var age: Int?
}

/*
 {
     "data": {
         "carouselTextList": null,
         "address": null,
         "occupation": "--",
         "gender": 1,
         "portraitUrl": "http://qn-video.xinliy.net/image/2023/6/168611649160.png",
         "black": 0,
         "chatServiceStatus": {
             "audioChatOn": true,
             "audioChatPrice": 0,
             "videoChatPrice": 0,
             "videoChatOn": true
         },
         "weight": 0,
         "callWaitTip": null,
         "follow": false,
         "userName": "乐观西柚汪",
         "userId": 14950,
         "verifiedFlag": false,
         "intimateFlag": false,
         "revenue": "--",
         "horoscope": "摩羯座",
         "advIds": null,
         "saiyuu": false,
         "vip": {
             "vipPrivilegeNum": 0,
             "isBlack": false,
             "vipTitile": "免费通话",
             "vipMemberTip": "开通解锁14大会员特权",
             "vipStars": 0,
             "isVip": 0,
             "vipIcon": ""
         },
         "age": 33,
         "topPrivilegeInfo": {
             "sendBackdrop": null,
             "receiveBackdrop": null,
             "topPrivilege": false,
             "fontColor": null
         },
         "chatRoom": {
             "roomAccid": 31671381,
             "name": "刘丽丽",
             "iconUrl": "http://qn-video.xinliy.net/system/nan9.png",
             "id": 31671381,
             "type": 2,
             "liveBroadcast": false
         },
         "height": 0
     },
     "content": "操作成功",
     "status": 200
 }
 */
