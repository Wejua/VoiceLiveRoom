//
//  MicrophoneModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/7.
//

import SwiftUI

//struct MicrophoneModel: Codable {
//    var data: DataModel
//    
//    struct DataModel: Codable {
//        
//    }
//}

struct RoomGiftListModel: Codable {
    var data: DataModel
    
    struct DataModel: Codable {
        var comboTime: Int? //
        var id: Int?
        var list: [GiftModel]?
        var name: String?
        
        struct GiftModel: Codable {
            var canSendSelf: Bool? //是否可自刷 true-可 false-不可
            var counts: Int?
            var expireTime: String?
            var gift: Int?
            var icon: String?
            var id: Int?
            var name: String?
            var path: String?
            var pathType: Int? //路径类型：1-svgaPath 2-gifPath 3-webpPath
            var tabId: Int?
            var unit: String?
            var voicePath: String?
            var worth: CGFloat?
            var worthUnit: Int?
        }
    }
}


struct EmotionListModel: Codable {
    var data: [DataModel]
    
    struct DataModel: Codable {
        var eid: Int?
        var expressionList: [EmotionModel]
        var zipPath: String 
        
        struct EmotionModel: Codable {
            var eid: Int
            var fileName: String
            var icon: String
            var name: String
            var type: Int
        }
    }
}
