//
//  User.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/25.
//

import Foundation
import UIKit
import SwiftUI

//let tokenKey = "userToken"


//class User: ObservableObject {
//    @Published var token: String? = UserDefaults.standard.string(forKey: tokenKey) {
//        willSet {
//            UserDefaults.standard.set(newValue, forKey: tokenKey)
//        }
//    }
//    @Published var info: UserInfoModel? = {
//        if let data = UserDefaults.standard.object(forKey: userInfoKey) as? Data {
//            let info = try? JSONDecoder().decode(UserInfoModel.self, from: data)
//            return info
//        } else {
//            return nil
//        }
//    }() {
//        willSet {
//            if let data = try? JSONEncoder().encode(newValue) {
//                UserDefaults.standard.set(data, forKey: userInfoKey)
//            }
//        }
//    }
//}

class LoginOrRegisterModel: ObservableObject, Codable {
    var content: String?
    var status: Int?
    var data: DataModel?
    
    class DataModel: ObservableObject, Codable {
        var event: String?
        var userInfo: UserInfoModel
    }
    
    class UserInfoModel: ObservableObject, Codable, Hashable {
        static func == (lhs: LoginOrRegisterModel.UserInfoModel, rhs: LoginOrRegisterModel.UserInfoModel) -> Bool {
            return lhs.uid == rhs.uid
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }
        
        var accid: Int?
        @Published var apiToken: String? //用户token
        var avatar: String?
        var banRights: Int? //封号权限，0：没有，1：风纪委员，2：管理员
        var bindAppleFlag: Bool? //是否绑定苹果 true-是 false-否
        var bindFacebookFlag: Bool? //是否绑定Facebook true-是 false-否
        var bindGoogleFlag: Bool? //是否绑定谷歌 true-是 false-否
        var bindHuaweiFlag: Bool? //是否绑定华为 true-是 false-否
        var bindWeiXinFlag: Bool? //是否绑定微信 true-是 false-否
        var completion: Int? //资料完成度
        var cookie: String? //注册后设置密码要用
        var gender: Gender? //
        var mobile: String?
        var nationCode: Int? //国家区号
        var netToken: String? //网易唯一标识
        var randomCode: Int? //随机串码
        var rongappid: String? //融云token
        var sayu: Bool? //
        var superAdmin: Bool?
        var title: String? //头衔
        var uid: Int //用户id
        var userName: String //用户名
        //自定义
        var phoneNum: String?
        
        init(uid: Int, userName: String) {
            self.uid = uid
            self.userName = userName
        }
        
        func encode(to encoder: Encoder) throws {
            var container: KeyedEncodingContainer<LoginOrRegisterModel.UserInfoModel.CodingKeys> = encoder.container(keyedBy: LoginOrRegisterModel.UserInfoModel.CodingKeys.self)
            try container.encodeIfPresent(self.accid, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.accid)
            try container.encodeIfPresent(self.apiToken, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.apiToken)
            try container.encodeIfPresent(self.avatar, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.avatar)
            try container.encodeIfPresent(self.banRights, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.banRights)
            try container.encodeIfPresent(self.bindAppleFlag, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindAppleFlag)
            try container.encodeIfPresent(self.bindFacebookFlag, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindFacebookFlag)
            try container.encodeIfPresent(self.bindGoogleFlag, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindGoogleFlag)
            try container.encodeIfPresent(self.bindHuaweiFlag, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindHuaweiFlag)
            try container.encodeIfPresent(self.bindWeiXinFlag, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindWeiXinFlag)
            try container.encodeIfPresent(self.completion, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.completion)
            try container.encodeIfPresent(self.cookie, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.cookie)
            try container.encodeIfPresent(self.gender, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.gender)
            try container.encodeIfPresent(self.mobile, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.mobile)
            try container.encodeIfPresent(self.nationCode, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.nationCode)
            try container.encodeIfPresent(self.netToken, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.netToken)
            try container.encodeIfPresent(self.randomCode, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.randomCode)
            try container.encodeIfPresent(self.rongappid, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.rongappid)
            try container.encodeIfPresent(self.sayu, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.sayu)
            try container.encodeIfPresent(self.superAdmin, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.superAdmin)
            try container.encodeIfPresent(self.title, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.title)
            try container.encode(self.uid, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.uid)
            try container.encode(self.userName, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.userName)
            try container.encodeIfPresent(self.phoneNum, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.phoneNum)
        }
        
        enum CodingKeys: CodingKey {
            case accid
            case apiToken
            case avatar
            case banRights
            case bindAppleFlag
            case bindFacebookFlag
            case bindGoogleFlag
            case bindHuaweiFlag
            case bindWeiXinFlag
            case completion
            case cookie
            case gender
            case mobile
            case nationCode
            case netToken
            case randomCode
            case rongappid
            case sayu
            case superAdmin
            case title
            case uid
            case userName
            case phoneNum
        }
        
        required init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<LoginOrRegisterModel.UserInfoModel.CodingKeys> = try decoder.container(keyedBy: LoginOrRegisterModel.UserInfoModel.CodingKeys.self)
            self.accid = try container.decodeIfPresent(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.accid)
            self.apiToken = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.apiToken)
            self.avatar = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.avatar)
            self.banRights = try container.decodeIfPresent(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.banRights)
            self.bindAppleFlag = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindAppleFlag)
            self.bindFacebookFlag = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindFacebookFlag)
            self.bindGoogleFlag = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindGoogleFlag)
            self.bindHuaweiFlag = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindHuaweiFlag)
            self.bindWeiXinFlag = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.bindWeiXinFlag)
            self.completion = try container.decodeIfPresent(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.completion)
            self.cookie = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.cookie)
            self.gender = try container.decodeIfPresent(Gender.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.gender)
            self.mobile = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.mobile)
            self.nationCode = try container.decodeIfPresent(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.nationCode)
            self.netToken = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.netToken)
            self.randomCode = try container.decodeIfPresent(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.randomCode)
            self.rongappid = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.rongappid)
            self.sayu = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.sayu)
            self.superAdmin = try container.decodeIfPresent(Bool.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.superAdmin)
            self.title = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.title)
            self.uid = try container.decode(Int.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.uid)
            self.userName = try container.decode(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.userName)
            self.phoneNum = try container.decodeIfPresent(String.self, forKey: LoginOrRegisterModel.UserInfoModel.CodingKeys.phoneNum)
        }
    }
}

//final class UserInfo: ObservableObject, Codable {
//   @Published var headImage: Data
//   @Published var nickName: String
//   @Published var birthDay: Int
//   @Published var birthMoth: Int
//   @Published var birthYear: Int
//   @Published var gender: Int //1是男，2是女
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.headImage = try container.decode(Data.self, forKey: .headImage)
//        self.nickName = try container.decode(String.self, forKey: .nickName)
//        self.birthDay = try container.decode(Int.self, forKey: .birthDay)
//        self.birthMoth = try container.decode(Int.self, forKey: .birthMoth)
//        self.birthYear = try container.decode(Int.self, forKey: .birthYear)
//        self.gender = try container.decode(Int.self, forKey: .gender)
//    }
//
//    enum CodingKeys: CodingKey {
//        case headImage
//        case nickName
//        case birthDay
//        case birthMoth
//        case birthYear
//        case gender
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.headImage, forKey: .headImage)
//        try container.encode(self.nickName, forKey: .nickName)
//        try container.encode(self.birthDay, forKey: .birthDay)
//        try container.encode(self.birthMoth, forKey: .birthMoth)
//        try container.encode(self.birthYear, forKey: .birthYear)
//        try container.encode(self.gender, forKey: .gender)
//    }
//}
