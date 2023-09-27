//
//  RankingListModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/27.
//

import Foundation

class RankingListModel: ObservableObject, Codable {
    var data: ListModel
}

class ListModel: Codable {
    var list:[ItemModel]
    var userInfo: UerInfoModel
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ListModel.CodingKeys> = try decoder.container(keyedBy: ListModel.CodingKeys.self)
        let list = try container.decode([ItemModel].self, forKey: ListModel.CodingKeys.list)
        for i in list.indices {
            if i > 0 {
                var string: String
                var diff = Double(list[i-1].charmNum - list[i].charmNum)
                if diff > 10000 {
                    diff = diff/10000.0
                    string = String(format: "%.2fw", diff)
                }
                string = String(format: "%.0f", diff)
                list[i].differWithLastOne = string
            }
            var num = Double(list[i].charmNum)
            var numStr: String
            if num > 10000 {
                num = num/10000.0
                numStr = String(format: "%.2f", num)
            }
            numStr = String(format: "%.0f", num)
            list[i].charmNumStr = numStr
        }
        self.list = list
        self.userInfo = try container.decode(UerInfoModel.self, forKey: ListModel.CodingKeys.userInfo)
    }
}

class UerInfoModel: Codable {
    var gender: Gender
    var avatar: String
    var nickName: String
    var uid: Int
    var charmNum: Int
    var onRank: Int //0表示未上榜
    var age: Int
    var difference: Int
}

class ItemModel: Codable {
    var avatar: String
    var gender: Gender
    var nickName: String
    var userLevel: Int
    var charmNum: Int
    var charmNumStr: String
    var age:Int
    var uid: Int
    var differWithLastOne: String
    
    enum CodingKeys: CodingKey {
        case avatar
        case gender
        case nickName
        case userLevel
        case charmNum
        case charmNumStr
        case age
        case uid
        case differWithLastOne
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        self.gender = try container.decodeIfPresent(Gender.self, forKey: .gender) ?? .female
        self.nickName = try container.decodeIfPresent(String.self, forKey: .nickName) ?? ""
        self.userLevel = try container.decodeIfPresent(Int.self, forKey: .userLevel) ?? 0
        self.charmNum = try container.decodeIfPresent(Int.self, forKey: .charmNum) ?? 0
        self.charmNumStr = try container.decodeIfPresent(String.self, forKey: .charmNumStr) ?? ""
        self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        self.uid = try container.decodeIfPresent(Int.self, forKey: .uid) ?? 0
        self.differWithLastOne = try container.decodeIfPresent(String.self, forKey: .differWithLastOne) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.gender, forKey: .gender)
        try container.encodeIfPresent(self.nickName, forKey: .nickName)
        try container.encodeIfPresent(self.userLevel, forKey: .userLevel)
        try container.encodeIfPresent(self.charmNum, forKey: .charmNum)
        try container.encodeIfPresent(self.charmNumStr, forKey: .charmNumStr)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.uid, forKey: .uid)
        try container.encodeIfPresent(self.differWithLastOne, forKey: .differWithLastOne)
    }
    
    init(avatar: String, gender: Gender, nickName: String, userLevel: Int, charmNum: Int, age: Int, uid: Int, differWithLastOne: String, charmNumStr: String) {
        self.avatar = avatar
        self.gender = gender
        self.nickName = nickName
        self.userLevel = userLevel
        self.charmNum = charmNum
        self.age = age
        self.uid = uid
        self.differWithLastOne = differWithLastOne
        self.charmNumStr = charmNumStr
    }
}
