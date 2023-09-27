//
//  APIs.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/24.
//

import Foundation
import UIKit
import Qiniu
import SwiftUI
import SwiftUITools

let baseUrl = "http://47.97.85.149:11888"

/*
 1. apiToken   登录之后获取到传入
 2. deviceId  设备唯一id标识
 3: deviceType  固定传1
 4: deviceName  设备品牌
 5: apiVersion  服务端版本号：405
 6: appOsVersion 手机系统版本
 7: appVersionCode     app版本
 8: appVersionName    app build版本
 9: appPackage  包名
 10: channel   固定App Store
 */
var otherHeader: [String:String] {
    [
    "apiToken":Store.shared.user.apiToken ?? "",
    "deviceId":identifierForVender,
    "deviceType":"1",
    "deviceName":deviceName,
    "apiVersion":"405",
    "appOsVersion":systemVersion,
    "appVersionCode":appVersion,
    "appVersionName":buildNumber,
    "appPackage":"VoiceChatRoom",
    "channel":"App Store",
    ]
}

struct API {
    struct Account {
        
        static func getBasicInfo(targetUid: Int) async throws -> BasicInfoModel {
            let url = baseUrl + "/api/user/info/getUserInfoSimple"
            let para = ["targetUid": targetUid]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let json = try JSON(data: data)["data"]
            let model = try JSONDecoder().decode(BasicInfoModel.self, from: json.rawData())
            return model
        }
        ///获取余额
        static func getBalance(completion: @escaping (Data?, Error?)->Void) {
            Requester.request(method: .GET, otherHeader: otherHeader, urlString: baseUrl+"/api/user/purse/assets", parameters: [:]) { data, error in
                completion(data, error)
            }
        }
        ///获取当前账号简单信息
        static func getMyInfo() async throws -> UserInfoModel {
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: baseUrl+"/api/user/info/getMySimple", parameters: [:])
            let model = try JSONDecoder().decode(UserInfoModel.self, from: data)
            return model
        }
        ///获取用户财富、魅力等级及心动值信息
        static func getGradesInfo(uid: Int) async throws -> UserGradeInfoModel {
            let url = baseUrl + "/api/user/info/loadRichesCharmHeartbeats"
            let para = ["uid":uid]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(UserGradeInfoModel.self, from: data)
            return model
        }
        ///获取礼物墙列表
        ///giftType: 礼物 类型 0、U币 2、钻石
        static func giftsList(giftType: Int, page:Int, tagUid:Int) async throws -> GiftsListModel {
            let url = baseUrl + "/api/user/gift/loadGiftWallList"
            let para = ["giftType":giftType, "pageNum":page, "pageSize":20, "tagUid":tagUid]
            let data = try await Requester.request(method:.POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(GiftsListModel.self, from: data)
            return model
        }
        ///isFamily: 是否是家族群聊送礼
        ///worthUnit: 0:U币类型礼物2:钻石类型礼物
        static func giftsInBackpack(isFamily: Bool, worthUnit: Int) async throws -> BackpackGiftsModel {
            let url = baseUrl + "/api/mychatRoom/warehouseToTab"
            let para = ["isFamily":isFamily, "worthUnit":worthUnit] as [String : Any]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(BackpackGiftsModel.self, from: data)
            return model
        }
        ///座驾列表
        static func getSeats(targetId: Int, page: Int) async throws -> SeatsModel {
            let url = baseUrl + "/api/user/getMountsList"
            let para = ["page":page, "size":20, "targetId":targetId]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(SeatsModel.self, from: data)
            return model
        }
        
        static func getMyRoom() async throws -> MyRoomModel {
            let url = baseUrl + "/api/mychatRoom/getMyRoom"
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: [:])
            let model = try JSONDecoder().decode(MyRoomModel.self, from: data)
            return model
        }
    }
}

extension API {
    struct Room {
        
        static func getRoomSeatInfo(roomId: Int) async throws -> RoomSeatInfoModel {
            let url = baseUrl + "/api/mychatRoom/getSeatInfoList"
            let para: [String: Any] = ["roomId":roomId]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(RoomSeatInfoModel.self, from: data)
            return model
        }
        
        /// 直播间礼物列表
        /// - Parameters:
        ///   - isFamily: 是否是家族群聊送礼
        ///   - targetUid: 对方用户id, 1v1聊天要传该字段
        ///   - type: 0:U币类型礼物2:钻石类型礼物
        /// - Returns: RoomGiftListModel
        static func roomGiftList(isFamily: Int, targetUid: Int?, type:Int) async throws -> RoomGiftListModel {
            let url = baseUrl + "/api/user/gift/getGiftList"
            var para: [String: Any] = ["isFamily":isFamily, "type":type]
            if let uid = targetUid {
                para["targetUid"] = uid
            }
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(RoomGiftListModel.self, from: data)
            return model
        }
        /// 禁麦、封麦位、音乐权限
        /// - Parameters:
        ///   - doType: 自己闭麦 1、是
        ///   - roomId: 房间ID
        ///   - seatNo: 座位号，0-7 ，7是老板位，设为旁听：-1
        ///   - status:  0否(解封) 1是
        ///   - type: 1:是否禁麦，2:是否封麦位，3:是否打开音乐权限
        static func microphoneSetting(doType: Int, roomId: Int?, seatNo: Int, status: Int, type: Int) async throws {
            let url = baseUrl + "/api/mychatRoom/setSeatLimits"
            var para: [String: Any] = ["doType":doType, "seatNo":seatNo, "status":status, "type":type]
            if let roomId = roomId {
                para["roomId"] = roomId
            }
            let _ = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
        }
        
        /// - Parameters:
        ///   - diversionType: 聊天室导流类型 0-进入(默认) 1-弹框 2-跟随 3-分享 4-重连 5-个播 6-为交友列表跟随进房 7-娱乐交友进房 8- 首页娱乐交友cp
        ///   - inviteEnterUid: 通过点击该用户的分享链接进入房间
        ///   - passWord:
        ///   - recommendUid: 通过点击该用户进房的用户uid
        ///   - roomId: 房间id
        /// - Returns: EnterRoomModel
        static func enterRoom(diversionType: Int, inviteEnterUid: Int?, passWord: String?, recommendUid: Int?, roomId: Int) async throws -> EnterRoomModel {
            let url = baseUrl + "/api/chatRoom/extension/enterRoom"
            var para: [String: Any] = ["diversionType":diversionType, "roomId":roomId]
            if let inviteEnterUid = inviteEnterUid {
                para["inviteEnterUid"] = inviteEnterUid
            }
            if let passWord = passWord {
                para["passWord"] = passWord
            }
            if let recommendUid = recommendUid {
                para["recommendUid"] = recommendUid
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(EnterRoomModel.self, from: data)
            return model
        }
        /// 房间列表
        ///   - type: -1附近 -2-推荐 -3-收藏 -4聊天室退出列表
        static func roomsList(page: Int, pageSize: Int, type: Int) async throws -> Data {
            let para = ["page":"\(page)", "size":"\(pageSize)", "type":"\(type)"]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: baseUrl+"/api/mychatRoom/getRoomList", parameters: para)
            return data
        }
        ///rtype: 1, 2；1:魅力榜,2:财富榜,3:新人榜,4:壕气榜
        ///type: 2,3,5；1:时榜,2:日榜,3:周榜,4:总榜,5:月榜
        static func rankingList(rtype:String, type:String, completion: @escaping (Data?, Error?)->Void) {
            let para = ["rtype":rtype, "type":type, "isLastRound":"0"]
            Requester.request(method: .GET, otherHeader: otherHeader, urlString: baseUrl+"/api/mychatRoom/richesCharmRankingAll", parameters: para) { data, error in
                completion(data, error)
            }
        }
        /// 搜索房间
        static func searchRoom(page: Int, searchKey: String) async throws -> SearchRoomModel {
            let url = baseUrl + "/api/mychatRoom/searchRoom"
            let para = ["page":page, "size":20, "searchKey":searchKey] as [String : Any]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(SearchRoomModel.self, from: data)
            return model
        }
        ///搜索用户
        static func searchUser(isShine: Int, page: Int, searchKey: String) async throws -> SearchUserModel {
            let url = baseUrl + "/api/user/searchUser"
            let para = ["isShine":isShine, "page":page, "searchKey":searchKey, "size":20] as [String : Any]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(SearchUserModel.self, from: data)
            return model
        }
        ///获取房间观众
        static func getRoomViewers(roomId: Int) async throws -> RoomViewersModel {
            let url = baseUrl + "/api/mychatRoom/getChatRoomPeopleNum"
            let para = ["roomId": roomId]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(RoomViewersModel.self, from: data)
            return model
        }
        ///获取房间成员列表, type: 查询类型 0-在线用户 1-爵位用户 2-被施魔法用户uid 3-幻影分身用户
        static func getRoomMembers(roomId: Int, page: Int, type: Int) async throws -> RoomMembersModel {
            let url = baseUrl + "/api/mychatRoom/getMembersByPageNew"
            let para: [String:Any] = ["page":page, "size":20, "roomId":roomId, "type":type]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(RoomMembersModel.self, from: data)
            return model
        }
        /// - Parameters:
        ///   - roomId: 房间ID
        ///   - seatNo: 座位ID，不传按顺序给位置，座位号0-8 ，7是老板位，8-主持位，-1（房主/主持在排队队列点确认上麦）
        ///   - serverOperation: 服务端操作
        ///   - targetUid: 目标用户id(如果是自己主动上下麦，该字段不传或者传用户自身id)
        ///   - type:  1上麦 2下麦
        /// - Returns: OnOrOffSeatModel
        static func onOrOffSeat(roomId: Int, seatNo: Int?, targetUid: Int, type: Int) async throws -> OnOrOffSeatModel {
            let url = baseUrl + "/api/mychatRoom/userGetOnSeat"
            var para: [String : Any] = ["apiVersion":otherHeader["apiVersion"]!, "roomId":roomId, "targetUid":targetUid, "type":type]
            if let seatNo = seatNo {
                para["seatNo"] = seatNo
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(OnOrOffSeatModel.self, from: data)
            return model
        }
        
        ///tabId: 1普通,2宝箱
        ///isWareHouse:是否是背包礼物0-不是 1-是
        ///wareHouseId: 背包礼物ID
        static func sendGift(canSendWall: Bool, giftId:Int, giftNum:Int, isWareHouse: Int, roomId: Int, sendUid:Int, tabId:Int, uidList: [Int], wareHouseId: Int) async throws -> SendGiftModel {
            let url = baseUrl + "/api/mychatRoom/sendGift"
            let para: [String: Any] = ["canSendWall":canSendWall, "giftId":giftId, "giftNum":giftNum, "isWareHouse":isWareHouse, "roomId":roomId, "sendUid":sendUid, "uidList":uidList, "wareHouseId":wareHouseId]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(SendGiftModel.self, from: data)
            return model
        }
        
        /// 收藏房间
        /// - Parameters:
        ///   - type: 1收藏 2取消收藏
        ///   - roomId: 房间ID
        /// - Returns: 返回是否操作成功
        static func favoriteRoom(roomId: Int, type: Int) async throws -> Bool {
            let url = baseUrl + "/api/mychatRoom/roomCollection"
            let para = ["roomId": roomId, "type":type]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let json = try JSON(data: data)
            if json["content"].stringValue == "操作成功" {
                return true
            } else {
                return false
            }
        }
        static func leaveRoom(roomId: String) async throws {
            let url = baseUrl + "/api/mychatRoom/leaveRoom"
            let para: [String:Any] = ["roomId":roomId]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            
        }
    }
}

extension API {
    struct IM {
        static func emotionList() async throws -> EmotionListModel {
            let url  = baseUrl + "/api/chat/support/expressionlist"
            let para: [String: Any] = [:]
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(EmotionListModel.self, from: data)
            return model
        }
        /// 动态列表，如果是获取动态首页的数据，不要传gender, uid
        /// gender: 0不区分男女，1男，2女
        /// type: 默认无，全部，1推荐，2关注
        static func momentsList(gender: Int?, keyword: String?, page: Int, type: Int?, uid: Int?) async throws -> MomentsListModel {
            let url = baseUrl + "/api/dyn/home"
            var para: [String:Any] = ["page":page, "size":20]
            if let gender = gender {
                para["gender"] = gender
            }
            if keyword != nil {
                para["keyword"] = keyword
            }
            if let type = type {
                para["type"] = type
            }
            if let uid = uid {
                para["uid"] = uid
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(MomentsListModel.self, from: data)
            return model
        }
        
        /// 拉黑/取消拉黑
        /// - Parameters:
        ///   - buid: 要拉黑/取消拉黑的人的id
        ///   - status: 0：取消黑名单，1：加入黑名单
        static func blockUser(buid: Int?, status: Int?) async throws -> Bool {
            let url = baseUrl + "/api/user/relation/cancelblack"
            var para: [String:Any] = [:]
            if let buid = buid {
                para["buid"] = buid
            }
            if let status = status {
                para["status"] = status
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let result = try JSON(data: data)["status"].intValue == 200
            return result
        }
        
        /// 黑名单列表
        /// - Parameter page: 当前页
        static func blackList(page: Int) async throws -> [BlackUserModel] {
            let url = baseUrl + "/api/user/relation/blacklist"
            let para = ["page": page, "size": 20]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let json = try JSON(data: data)["data"]
            let users = try JSONDecoder().decode([BlackUserModel].self, from: json.rawData())
            return users
        }
        
        /// 消息列表
        static func messageList(idsList: [String]) async throws -> MessageListModel {
            let url = baseUrl + "/api/user/loadUserProfileList"
            let para = ["idsList":idsList]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(MessageListModel.self, from: data)
            return model
        }
    
        /// 是否关注
        static func isAttention(userId: Int) async throws -> IsFollowModel {
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: baseUrl+"/api/user/isFollow", parameters: ["userId": userId])
            let model = try JSONDecoder().decode(IsFollowModel.self, from: data)
            return model
        }
        ///status: 0, 1
        ///uidRels: [uid, uid]
        static func attention(uidRels: [Int], status: Int) async throws -> Bool {
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: baseUrl+"/api/user/relation/followuser", parameters: ["uidRels":uidRels, "status":status])
//            let model = try JSONDecoder().decode(AttentionModel.self, from: data)
            let result = try JSON(data: data)["status"].intValue == 200
            return result
        }
        /// 关注列表
        /// type: 类型 1、在聊天室
        static func attentionList(keyWord: String?, page: Int) async throws -> AttentionListModel {
            let url = baseUrl + "/api/user/relation/followlist"
            var para: [String: Any] = ["page":page, "size":20]
            if keyWord != nil {
                para["keyWord"] = keyWord
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(AttentionListModel.self, from: data)
            return model
        }
        /// 朋友列表
        static func friendsList(keyWord: String?, page: Int, type: Int) async throws -> FriendsListModel {
            let url = baseUrl + "/api/user/relation/goodFriendList"
            var para: [String:Any] = ["page":page, "size":20, "type":type]
            if keyWord != nil {
                para["keyWord"] = keyWord
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(FriendsListModel.self, from: data)
            return model
        }
        ///粉丝列表
        static func fansList(keyWord: String?, page: Int, type: Int) async throws -> FansListModel {
            let url = baseUrl + "/api/user/relation/fensilist"
            var para: [String:Any] = ["page":page, "size":20, "type":type]
            if keyWord != nil {
                para["keyWord"] = keyWord
            }
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(FansListModel.self, from: data)
            return model
        }
    }
}

extension API {
    struct Login {
        /// 获取验证码
        /// - Parameters:
        ///   - phoneNum: 电话号码
        ///   - smsType: 1-登录注册 2-找回密码 3-修改密码 4-修改手机号 5-修改转接号码
        ///   - type: 1-短信 2-语音
        ///   - completion: 回调
        static func sendVerifyCode(phoneNum: String, smsType: Int, type: Int, completion: @escaping (Data?, Error?)-> Void) {
            let prara = ["phone":phoneNum,"smsType":smsType,"type":type] as [String : Any]
            Requester.request(method: .POST, otherHeader: [:], urlString: baseUrl+"/api/sms/getVerifyCode", parameters: prara) { data, error in
                completion(data, error)
            }
        }
        
        //上传图片
        static func uploadImage(image: UIImage) async throws -> String {
            let url = baseUrl+"/api/sys/getQiniuToken"
            let para = [String:Any]()
            let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: para)
            guard let token = try JSON(data: data)["data"].string else {fatalError("token为空")}
            guard let pngData = image.pngData() else {fatalError("图片出错")}
            let date = Date()
            let key = "image/\(date.year)/\(date.month)/" + "\(Int64(date.timeIntervalSince1970))\(Int.random(in: 1..<1000)).png"
            return try await QNHelper.qNUploadWith(data: pngData, key: key, token: token)
        }
        
        //修改用户信息
        static func editUserInfo(token:String, imageKey: String, nickName: String, birthDate: Date, gender: Int) async throws -> Data {
            let url = baseUrl+"/api/user/info/editUserInfo"
            let para: [String:Any] = ["avatar":imageKey, "birthday":birthDate.day, "birthmonth":birthDate.month, "birthyear":birthDate.year, "gender":gender, "nickName":nickName]
            var otherHeader = otherHeader
            otherHeader["apiToken"] = token
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let json = try JSON(data: data)
            if json["content"] == "操作成功" {
                //更新Store.userInfo中的头像，名字，生日，性别
            }
            return data
        }
        
        //手机号登录
        static func loginWithPhoneNum(phoneNum: String, stringCode: String) async throws -> LoginOrRegisterModel {
            let url = baseUrl+"/api/user/logOrReg"
            let para = ["mobile":phoneNum, "nationCode":"86", "verifyCode":stringCode]
            let data = try await Requester.request(method: .POST, otherHeader: otherHeader, urlString: url, parameters: para)
            let model = try JSONDecoder().decode(LoginOrRegisterModel.self, from: data)
            return model
        }
    }
}

extension API {
    struct Community {
//        static func momentsHomeList() async throws -> CommunityHomeModel {
//
//        }
    }
}

class QNHelper {
    enum UploadError: Error {
        case nilError
    }
    static func qNUploadWith(data: Data, key: String, token: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            QNUploadManager().put(data, key: key, token: token, complete: { info, key, resp in
                if info?.isOK == true, let key = key {
                    continuation.resume(returning: key)
                } else {
                    if let error = info?.error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: UploadError.nilError)
                    }
                }
            }, option: nil)
        }
    }
}


