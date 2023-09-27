//
//  MessagePageView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/22.
//

import SwiftUI
import SwiftUITools

extension Notification {
    static let updateMessageList = Notification.Name.init("updateMessageListName")
}

struct MessagePageView: View {
    enum ListType: String, CaseIterable {
        case xiaoxi = "消息"
        case haoyou = "好友"
    }
    
    @State private var currentListType: ListType = .xiaoxi
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ForEach(ListType.allCases, id:\.self) { type in
                    let fontN: CommonFontNames = type == currentListType ? .PingFangSCSemibold : .PingFangSCRegular
                    let fontS: CGFloat = type == currentListType ? 18 : 16
                    let color: Color = type == currentListType ? .white : .white.opacity(0.6)
                    Text(type.rawValue)
                        .textSett(color: color, FName: fontN, Fsize: fontS, lineLi: 1, maxW: nil)
                        .onTapGesture {
                            currentListType = type
                        }
                }
                Spacer()
//                Image("xiaoxi_tianjiahaoyou")
//                    .padding(.trailing, 25)
                
                Text("发送给另一个号")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 20, lineLi: nil)
                    .onTapGesture {
                        Task {
                            let successed = try await RongYunManager.shared.sendTextMessage(message: "你好呀Test", targetId: "15022")//14950
                            if successed {
                                NotificationCenter.default.post(name: Notification.updateMessageList, object: nil)
                            }
                        }
                    }
            }
            .frame(height: 44)
            .padding(.leading, 16)
            TabView(selection: $currentListType) {
                MessagesView().tag(ListType.xiaoxi)
                FriendsView().tag(ListType.haoyou)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct MessagePageView_Previews: PreviewProvider {
    static var previews: some View {
        MessagePageView()
    }
}
