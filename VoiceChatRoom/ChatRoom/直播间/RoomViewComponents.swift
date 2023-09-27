//
//  RoomViewComponents.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/24.
//

import SwiftUI

extension RoomView {
    @ViewBuilder func bottomToolsView() -> some View {
        HStack(spacing: 8) {
            TextField("", text: $text, prompt: Text("说点啥").foregroundColor(.white))
                .TextFieldSett(textC: .white, cursorC: .white, fontN: .PingFangSCRegular, fontS: 14)
                .padding([.top, .bottom, .trailing], 8)
                .padding(.leading, 15)
                .frame(height: 32)
                .background("#FFFFFF".color(alpha: 0.1))
                .cornerRadius(16)
                .onSubmit {
                    
                }
                .padding(.trailing, 2)
            
            Image("roomgengduo")
                .onTapGesture {
                    showRoomMemberList.toggle()
                }
            let imageN = mute ? "roomUnvoice" : "roomvoice"
            ///通过声网消除房间声音
            Image(imageN)
                .onTapGesture {
                    mute.toggle()
                    AgoraManager.shared.agoraKit?.muteLocalAudioStream(mute)
                }
            Image("roomgifticon")
                .onTapGesture {
                    showGiftList.toggle()
                }
            
            Image("roommessagebutton")
                .onTapGesture {
                    Store.shared.navigationPath.append("roomMessageView")
                }
                
            if selfIsOnSeat == true {
                let imageName = disableMicrophone ? "roommute" : "roomUnmute"
                Image(imageName)
                    .onTapGesture {
                        Task {
                            if let seatId = selfSeatModel?.seatId {
                                try await API.Room.microphoneSetting(doType: 1, roomId: roomId, seatNo: seatId, status: disableMicrophone ? 0 : 1, type: 1)
                            }
                        }
                    }
            }
            //上麦
            Image("lianmai")
                .onTapGesture {
                    Task {
                        let _ = try await API.Room.onOrOffSeat(roomId: roomId, seatNo: nil, targetUid: selfId, type: 1)
                    }
                }
        }
        .padding([.leading, .trailing], 12)
    }
}
