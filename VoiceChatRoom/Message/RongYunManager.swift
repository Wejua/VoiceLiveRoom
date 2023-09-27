//
//  RongYunManager.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/12.
//

import Foundation
import RongIMLib
import RongIMLibCore
import SwiftUITools

class RongYunManager: NSObject {
    static let shared = RongYunManager()
    
    var client: RCIMClient = RCIMClient.shared()
    
    var token: String?
    
    private var hasSetup: Bool = false
    
    #if DEBUG
    var appkey = "0vnjpoad039zz"
    #else
    var appkey = ""
    #endif
    
    enum RongYunConnectError: Error {
        case fail(code: RCConnectErrorCode)
    }
    func setup() async throws -> Bool {
        client.initWithAppKey(appkey)
        client.setReceiveMessageDelegate(self, object: nil)
        let token = try await getToken()
        return try await withCheckedThrowingContinuation { continuation in
            client.connect(withToken: token) { dbCode in
                //本地数据库打开
            } success: { userID in
                continuation.resume(returning: true)
                self.hasSetup = true
            } error: { code in
                continuation.resume(throwing: RongYunConnectError.fail(code: code))
            }
        }
    }
    
    @MainActor private func getToken() async throws -> String {
        let url = baseUrl + "/api/user/getRongAppid"
        let data = try await Requester.request(method: .GET, otherHeader: otherHeader, urlString: url, parameters: [:])
        let token = try JSON(data: data)["data"]["rongappid"].stringValue
        return token
    }
}

//接收消息
extension RongYunManager: RCIMClientReceiveMessageDelegate {
//    func onReceived(_ message: RCMessage, left nLeft: Int32, object: Any?) {
//        print("onReceived")
//    }
}

extension RongYunManager {
    //发送消息,单聊
    func sendTextMessage(message: String, targetId: String) async throws -> Bool {
        if !hasSetup { let _ = try await setup() }
        let content = RCTextMessage(content: message)
        let rcMsg = RCMessage(type: .ConversationType_PRIVATE, targetId: targetId, direction: .MessageDirection_SEND, content: content)
        return try await withCheckedThrowingContinuation { continuation in
            RCIMClient.shared().send(rcMsg, pushContent: nil, pushData: nil) { msg in
                continuation.resume(returning: true)
            } errorBlock: { code, msg in
                continuation.resume(returning: false)
            }
        }
    }
    
    //会话列表
    func getSessionList(startTime: Int64 = 0) async throws -> [RCConversation]? {
        if !hasSetup { let _ = try await setup() }
        let typeList = [NSNumber(value: RCConversationType.ConversationType_PRIVATE.rawValue)]
        let list = client.getConversationList(typeList, count: 20, startTime: startTime)
        return list
    }
    
    ///获取历史消息
    ///oldestMessageId: ID 不存在时，设置为 -1，表示获取最新的 count 条消息。
    func getHistoryMessages(targetId: String, oldestMessageId: Int) async throws -> [RCMessage]? {
        if !hasSetup { let _ = try await setup() }
        let messages = client.getHistoryMessages(.ConversationType_PRIVATE, targetId: targetId, oldestMessageId: oldestMessageId, count: 20)
        return messages
    }
    
    //发送消息回执
    func sendMessageRececipt(targetId: String, messageList: [RCMessage]) async throws -> Bool {
        if !hasSetup { let _ = try await setup() }
        return try await withCheckedThrowingContinuation { continuation in
            client.sendReadReceiptResponse(.ConversationType_PRIVATE, targetId: targetId, messageList: messageList) {
                continuation.resume(returning: true)
            } error: { code in
                continuation.resume(returning: false)
            }
        }
    }
    
    //所有会话总未读数
    func totalUnreadCount() async throws -> Int32 {
        if !hasSetup { let _ = try await setup() }
        return client.getTotalUnreadCount()
    }
}

//room
extension RongYunManager {
    enum RCCodeError: Error {
        case fail(code: RCErrorCode)
    }
    func joinChatRoom(roomId: String) async throws -> Bool {
        if !hasSetup { let _ = try await setup() }
        return try await withCheckedThrowingContinuation { continuation in
            RCIMClient.shared().joinExistChatRoom(roomId, messageCount: 20) {
                continuation.resume(returning: true)
            } error: { error in
                continuation.resume(returning: false)
            }
        }
    }
    
    func exitChatRoom(roomId: String) async throws -> Bool {
        if !hasSetup { let _ = try await setup() }
        return try await withCheckedThrowingContinuation { continuation in
            RCIMClient.shared().quitChatRoom(roomId) {
                continuation.resume(returning: true)
            } error: { code in
                continuation.resume(throwing: RCCodeError.fail(code: code))
            }
        }
    }
    
    /// - Parameters:
    ///   - roomId: RoomId
    ///   - oldestMessageId: ID 不存在时，设置为 -1，表示获取最新的 count 条消息。
    ///   - recordTime: 首次不用传，之后返回后再传
    /// - Returns: ([RCMessage]?, Int64?)
    func getRoomHistoryMessages(roomId: String, oldestMessageId: Int, recordTime: Int64?) async throws -> ([RCMessage]?, Int64?) {
        if !hasSetup { let _ = try await setup() }
        let histories = client.getHistoryMessages(.ConversationType_CHATROOM, targetId: roomId, oldestMessageId: oldestMessageId, count: 20)
        if histories?.count == 0 {
            return try await withCheckedThrowingContinuation { continuation in
                let recordTime = recordTime != nil ? recordTime! : 0
                client.getRemoteChatroomHistoryMessages(roomId, recordTime: recordTime, count: 20, order: .timestamp_Asc) { messages, time in
                    continuation.resume(returning: (messages, time))
                } error: { code in
                    continuation.resume(throwing: RCCodeError.fail(code: code))
                }
            }
        } else {
            return (histories, nil)
        }
    }
}



