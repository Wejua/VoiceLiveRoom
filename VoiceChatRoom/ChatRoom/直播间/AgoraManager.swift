//
//  AgoraManager.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/27.
//

import Foundation
import AgoraRtcKit

class AgoraManager: NSObject {
    static let shared = AgoraManager()
    
    var agoraKit: AgoraRtcEngineKit?
    
    func setup(token: String?, channelId: String, uid: UInt) {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "ea58db2bda5f419b96f82d90e6010b8b", delegate: self)
        agoraKit?.setChannelProfile(.liveBroadcasting)
        agoraKit?.setClientRole(.audience)
        agoraKit?.setAudioProfile(.default)
        agoraKit?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: uid)
    }
}

extension AgoraManager: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        //成功加入房间/频道
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        // 当前用户发生角色变化
    }
}
