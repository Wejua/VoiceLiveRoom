//
//  MessagesView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/15.
//

import SwiftUI
import RongIMLibCore

struct MessagesView: View {
    @State private var conversations: [RCConversation]?
    @State var isRoomMessageView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isRoomMessageView {
                messageListView()
            } else {
                notificationView()
                commentAndThumbsupAndNoti()
                Rectangle().fill("#282828".color!)
                    .frame(height: 12)
                messageListView()
                    .padding(.bottom, 53)
            }
        }
        .background("#050017".color)
        .topSafeAreaColor(color: "#050017".color)
        .bottomSafeAreaColor(color: "#050017".color)
        .onAppear {
            Task {
                self.conversations = try await RongYunManager.shared.getSessionList()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.updateMessageList)) { _ in
            Task {
                self.conversations = try await RongYunManager.shared.getSessionList()
            }
        }
    }
    
    func messageListView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(conversations ?? [], id: \.targetId) { conversation in
                    MessageCell(conversation: conversation)
                }
            }
        }
    }
    
    func commentAndThumbsupAndNoti() -> some View {
        HStack(spacing: 0) {
            commentView()
            
            Spacer()
            
            thumbsupView()
            
            Spacer()
            
            notifactionsView()
        }
        .padding(.top, 10)
        .padding([.leading, .trailing], 40)
        .padding(.bottom, 12)
    }
    
    func notificationView() -> some View {
        HStack(spacing: 0) {
            Image("xiaoxi_laba")
                .padding([.leading, .trailing], 12)
            Text("开启通知, 第一时间查收每一份精彩～")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 13, lineLi: 1, maxW: nil)
            Spacer()
            Image("xiaoxi_qukaiqi")
                .padding(.trailing, 12)
        }
        .frame(height: 44)
        .background("#FCCC46".color!.opacity(0.2))
        .cornerRadius(12)
        .padding([.leading, .trailing], 15)
        .padding(.top, 10)
    }
    
    private func commentView() -> some View {
        NavigationLink {
            NotificationsView()
        } label: {
            VStack(spacing: 6) {
                Image("xiaoxi_pinglun")
                Text("评论")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 10, lineLi: 1, maxW: nil)
            }
        }
    }
    
    private func thumbsupView() -> some View {
        NavigationLink {
            NotificationsView()
        } label: {
            VStack(spacing: 6) {
                Image("xiaoxi_dianzan")
                Text("点赞")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 10, lineLi: 1, maxW: nil)
            }
        }
    }
    
    private func notifactionsView() -> some View {
        NavigationLink {
            SystemNotificationView()
        } label: {
            VStack(spacing: 6) {
                Image("xiaoxi_tongzhi")
                Text("通知")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 10, lineLi: 1, maxW: nil)
            }
        }
    }
}

struct MessageCell: View {
    @State var basicInfoModel: BasicInfoModel?
    var conversation: RCConversation
    
    var body: some View {
        NavigationLink {
            MessageDetailView(conversationId: conversation.targetId, basicInfo: $basicInfoModel)
        } label: {
            content()
                .onAppear {
                    if let uid = Int(conversation.targetId) {
                        Task { @MainActor in
                            self.basicInfoModel = try await API.Account.getBasicInfo(targetUid: uid)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder func content() -> some View {
        HStack(alignment:.top, spacing: 0) {
            let url = URL(string: basicInfoModel?.portraitUrl ?? "")
            AsyncImage(url: url, content: {$0.resizable().scaledToFill()}, placeholder: {Color.gray})
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                .padding(.leading, 15)
                .overlay(alignment: .topTrailing) {
                    let count = Int(conversation.unreadMessageCount)
                    if count > 0 {
                        MessageCount(count: count)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 7) {
                    let name = basicInfoModel?.userName ?? ""
                    Text(name)
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 15, lineLi: 1, maxW: nil)
                    Spacer()
                    Text(conversation.sentTime.format())
                        .textSett(color: "#93949D".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1, maxW: nil)
                        .padding(.trailing, 15)
                }
                let text = (conversation.lastestMessage as? RCTextMessage)?.content ?? ""
                Text(text)
                    .textSett(color: "#93949D".color!, FName: .PingFangSCRegular, Fsize: 13, lineLi: 1)
                    .padding(.trailing, 15)
            }
            .padding(.leading, 10)
        }
        .frame(height: 76)
        .overlay(alignment: .bottom) {
            Rectangle().fill("#282828".color!)
                .frame(height: 1)
                .padding(.leading, 77)
        }
    }
}

struct MessageCount: View {
    var count: Int
    
    var body: some View {
        Circle().fill("#FF3E3E".color!)
            .frame(width: 16, height: 16)
            .overlay {
                Text("\(count)")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 13, lineLi: 1)
                    .offset(y: -0.5)
            }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
