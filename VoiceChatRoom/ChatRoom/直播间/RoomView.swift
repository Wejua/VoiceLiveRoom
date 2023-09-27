//
//  RoomView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/17.
//

import SwiftUI
import ModalPresenter
import SwiftUITools
import RongIMLib

struct RoomView: View {
    /// 房间ID
    var roomId: Int
    /// 是否显示（举报/切换房型，最小化, 关闭）弹窗
    @State var showMore: Bool = false
    /// 是否是房主
    @State var isRoomOwner: Bool = false
    /// 是否显示底部成员列表弹窗
    @State var showRoomMemberList: Bool = false
    /// 是否显示底部用户信息弹窗
    @State var showMemberInfo: Bool = false
    /// 是否弹出礼物列表
    @State var showGiftList: Bool = false
    /// 是否显示举报页面
    @State var showReportView: Bool = false
    /// 最小化
    @Binding var minimize: Bool
    /// 关闭/打开直播间
    @Binding var showRoomView: Bool
    /// 是否显示不支持该类型房间提示
    @State var showToast: Bool = false
    /// 输入框内容
    @State var text: String = ""
    /// 是否关注了当前房间
    @State var isAttention: Bool = false
    
    @State var showAnnouncementAlert: Bool = false
    /// 点击头像显示下麦/踢出房间，查看资料
    @State var showActionSheet: Bool = false
    
    @State var actionSheetTitle: String?
    /// 当前被点击头像的uid
    @State var currentUid: Int?
    /// 禁麦
    @State var disableMicrophone: Bool = false
    ///静音
    @State var mute: Bool = false
    
    @State var enterRoomModel: EnterRoomModel?
    @State var viewersModel: RoomViewersModel?
    @State var seatsModel: RoomSeatInfoModel?
    @State var membersModel: RoomMembersModel?
    @State var messages: [RCMessage]?
    @State var messagesRecordTime: Int64?
    
    @Environment(\.dismiss) var dismiss
    
    init(roomId: Int, showRoomView: Binding<Bool>, minimize: Binding<Bool>) {
        self.roomId = roomId
        self._showRoomView = showRoomView
        self._minimize = minimize
    }
    
    var body: some View {
        ZStack {
            normalContent()
                .background(primaryColor)
        }
        .sheet(isPresented: $showReportView) {
            ReportView()
        }
        .toast(message: "暂不支持此房型", isShowing: $showToast, duration: 0.3)
        .alert("公告", isPresented: $showAnnouncementAlert, actions: {
            Button("确定", role: .cancel) {
                dismiss()
            }
        }, message: {
            Text(enterRoomModel?.data.announcement ?? "")
        })
        .confirmationDialog("", isPresented: $showActionSheet, actions: {
            if let title = actionSheetTitle {
                Button(title) {
                    if title == "下麦" {
                        
                    } else if title == "踢出房间" {
                        
                    }
                }
                Button("查看资料") {
                    showMemberInfo.toggle()
                }
            }
        })
        .onAppear {
            loadData()
        }
        .toolbar(.hidden)
    }
        
    @MainActor private func loadData() {
        Task {
            async let enterRoomModel = API.Room.enterRoom(diversionType: 0, inviteEnterUid: nil, passWord: nil, recommendUid: nil, roomId: roomId)
            async let membersModel = API.Room.getRoomMembers(roomId: roomId, page: 1, type: 0)
            async let seatsModel = API.Room.getRoomSeatInfo(roomId: roomId)
            async let viewersModel = API.Room.getRoomViewers(roomId: roomId)
            async let messages = RongYunManager.shared.getRoomHistoryMessages(roomId: String(roomId), oldestMessageId: -1, recordTime: nil)

            self.viewersModel = try await viewersModel
            self.enterRoomModel = try await enterRoomModel
            self.membersModel = try await membersModel
            self.seatsModel = try await seatsModel
            self.messages = try await messages.0
            self.messagesRecordTime = try await messages.1
            
            AgoraManager.shared.setup(token: self.enterRoomModel?.data.agoraToken, channelId: String(roomId), uid: UInt(selfId))
            
            isAttention = try await enterRoomModel.data.isFavorited ?? false
            
            if self.enterRoomModel?.data.roomType != 2 {
                showToast = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    showRoomView = false
//                }
            }
        }
    }
    
    @ViewBuilder private func normalContent() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                roomOwnerAndViewersView()
                
                Image("noticeicon")
                    .padding(.leading, 12)
                    .padding(.top, 13)
                    .onTapGesture {
                        showAnnouncementAlert.toggle()
                    }
                
                seatsView()
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                commentsView(messages: messages)
                
            }
            .background {
                if let url = enterRoomModel?.data.background {
                    CachedAsyncImage(url: URL(string: url)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomToolsView()
            }
            .overlay(alignment: .bottomTrailing) {
                Image("flotingButton")
                    .padding(.trailing, 15)
                    .padding(.bottom, 115)
            }
            
            sheets()
        }
    }

}

extension RoomView {
    /// 座位数
    var seatNum: Int? {
        return enterRoomModel?.data.seatNum
    }
    
    var selfIsManager: Bool {
        let host = onSeatList?.filter{$0.uid == 8}.first
        let userType = enterRoomModel?.data.userType
        let selfIsManager = userType == 1 || userType == 2 || host?.uid == selfId
        return selfIsManager
    }
    
    var onSeatList: [RoomSeatInfoModel.SeatModel]? {
        return seatsModel?.data
    }
    
    var selfId: Int {
        return Store.shared.user.uid
    }
    
    var selfIsOnSeat: Bool? {
        return onSeatList?.contains { ele in
            ele.uid == selfId
        }
    }
    
    var selfSeatModel: RoomSeatInfoModel.SeatModel? {
        return onSeatList?.filter{$0.uid == selfId}.first
    }
    
    var host: RoomSeatInfoModel.SeatModel? {
        onSeatList?.filter{$0.seatId == 8}.first
    }
    
    var isThreeRoom: Bool {
        seatNum == 3
    }
    
    func changeIndexToSeatNo(index: Int) -> Int {
        var seatId = index
        if seatId == 8 || seatId == 9 {seatId += 2}
        return seatId
    }
    
    /// 确认是否要显示，下麦，踢出房间ActionSheet, 返回是否要显示ActionSheet
    func checkActionSheetButtonTitle() -> Bool {
        var title: String?
        if currentUid == selfId && selfIsOnSeat == true {
            title = "下麦"
        }
        if selfIsManager && currentUid != selfId {
            title = "踢出房间"
        }
        actionSheetTitle = title
        if title != nil {
            return true
        }
        return false
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(roomId: 0, showRoomView: .constant(false), minimize: .constant(false))
    }
}
