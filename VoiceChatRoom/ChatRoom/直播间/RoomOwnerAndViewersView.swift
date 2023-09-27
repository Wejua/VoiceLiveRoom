//
//  HostOrOwnerAndViewersAndMoreButton.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/24.
//

import SwiftUI
import SwiftUITools

extension RoomView {
    
    @ViewBuilder func roomOwnerAndViewersView() -> some View {
        HStack(spacing: 0) {
            hostOrOwnerInfo()
            
            Spacer(minLength: 6)
            
            viewersAndMoreButtonView()
        }
        .padding([.leading, .trailing], 16)
    }
    
    @ViewBuilder private func hostOrOwnerInfo() -> some View {
        HStackLayout(spacing: 6) {
            let avatar = host?.avatar
            let roomName = enterRoomModel?.data.roomName ?? ""
            let hostAndRoomName = host?.username != nil ? host!.username! + "-\(roomName)" : roomName
            let url = URL(string: avatar ?? "")
            CachedAsyncImage(url: url) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image("rentouzhanwen").resizable().scaledToFit()
            }
            .frame(width: 27, height: 27)
            .clipShape(Circle())
            .onTapGesture {
                currentUid = host?.uid
                showMemberInfo.toggle()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(hostAndRoomName)")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 13, lineLi: 1)
                
                Text(String(format:"ID:%d", roomId))
                    .foregroundColor("ffffff".color(alpha: 0.5))
                    .font(name: .PingFangSCRegular, size: 9)
            }
            
            attentionButton()
        }
        .frame(maxWidth: 193, alignment: .leading)
    }
    
    @ViewBuilder private func attentionButton() -> some View {
        let attensionT = isAttention ? "取关" : "关注"
        Text(attensionT)
            .foregroundColor(.white)
            .font(name: .PingFangSCRegular, size: 12)
            .frame(width: 42, height: 24)
            .background("#000000".color(alpha: 0.3))
            .cornerRadius(12)
            .onTapGesture {
                Task { @MainActor in
                    let result = try await API.Room.favoriteRoom(roomId: roomId, type: isAttention ? 2 : 1)
                    if result {
                        self.isAttention.toggle()
                    }
                }
            }
    }
    
    @ViewBuilder private func viewersAndMoreButtonView() -> some View {
        HStack(spacing: 4) {
            ForEach(viewersModel?.data.userList ?? [], id:\.uid) { user in
                let url = URL(string: user.avatar)
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    placeHolderColor
                }
                .frame(width: 23, height: 23)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .strokeBorder("#D87D68".color!, lineWidth: 1)
                }
                .onTapGesture {
                    currentUid = user.uid
                    showMemberInfo.toggle()
                }
            }
            
            Image("roomMorebutton")
                .padding(.leading, 8)
                .onTapGesture {
                    showMore.toggle()
                }
        }
    }
}
