//
//  HomeSearch.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/19.
//

import SwiftUI
import SwiftUITools

struct HomeSearch: View {
    enum SearchContentType: String, CaseIterable {
        case zhonghe = "综合"
        case yonghu = "用户"
        case liaotianshi = "聊天室"
    }
    @State private var text: String = "10564"
    @State private var currentType: SearchContentType = .zhonghe
    @State private var roomModel: SearchRoomModel?
    @State private var userModel: SearchUserModel?
    
    var body: some View {
        VStack(spacing: 0) {
            segmentView()
                .padding(.top, 10)
                .padding(.leading, 4)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    if let userItems = userModel?.data, currentType == .zhonghe || currentType == .yonghu {
                        Section {
                            ForEach(userItems, id: \.uid) { model in
                                UserItem(model: model)
                            }
                        } header: {
                            userHeader()
                        }
                    }
                    if let roomItems = roomModel?.data, currentType == .zhonghe || currentType == .liaotianshi {
                        Section {
                            ForEach(roomItems, id: \.roomId) { room in
                                RoomItem(model: room)
                            }
                        } header: {
                            roomHeader()
                        }
                    }
                }
            }
        }
        .background("#050017".color)
        .ignoresSafeArea(edges: .bottom)
        .topSafeAreaColor(color: "#050017".color)
        .customBackView {
            Image("backArrow")
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 16) {
                    HStack(spacing: 8){
                        Image("homeSearchSearch")
                        TextField("", text: $text, prompt: nil)
                            .TextFieldSett(textC: .white, cursorC: .white, fontN: .PingFangSCRegular, fontS: 14)
                    }
                    .frame(height: 40)
                    .padding(.leading, 13)
                    .background("#504D5D".color)
                    .cornerRadius(20)
                    Text("搜索")
                        .textSett(color: "#6A6A71".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1, maxW: nil)
                        .onTapGesture {
                            Task {
                                async let model = API.Room.searchRoom(page: 1, searchKey: text)//"40156037"
                                async let userModel = API.Room.searchUser(isShine: 1, page: 1, searchKey: text)
                                self.roomModel = try await model
                                self.userModel = try await userModel
                            }
                        }
                }
            }
        }
    }
    
    private func roomHeader() -> some View {
        HStack(spacing: 0) {
            Text("相关聊天室")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                .frame(height: 46)
                .padding(.leading, 15)
            Spacer()
        }
        .background("#050017".color)
    }
    
    private func userHeader() -> some View {
        HStack(spacing: 0) {
            Text("相关用户")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                .frame(height: 46)
                .padding(.leading, 15)
            Spacer()
        }
        .background("#050017".color)
    }
    
    private func segmentView() -> some View {
        HStack(spacing: 12) {
            ForEach(SearchContentType.allCases, id: \.self) { type in
                let textColor = currentType == type ? "#FCCC46".color! : Color.white
                Text(type.rawValue)
                    .textSett(color: textColor, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                    .frame(width: 60, height: 28)
                    .ifdo(currentType==type, transform: { view in
                        view.background("#FCCC46".color(alpha: 0.1))
                    })
                    .cornerRadius(14)
                    .onTapGesture {
                        currentType = type
                    }
            }
            Spacer()
        }
    }
}

struct UserItem: View {
    
    var model: SearchUserModel.SearchUserDataModel
    @State private var isFollow: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            let url = URL(string: model.avatar)
            CachedAsyncImage(url: url, content: {$0}, placeholder: {Color.gray})
                .frame(width: 50, height: 50)
                .padding([.top, .bottom], 12)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 0) {
                Text("\(model.userName)")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                HStack(spacing: 4) {
                    Text(String(format:"ID:%d", model.uid))
                        .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1, maxW: nil)
                    Image("homeSearchCopy")
                }
                .onTapGesture {
                    UIPasteboard.general.string = String(format:"%d", model.uid)
                }
            }
            .padding(.leading, 10)
            Spacer()
            let text = isFollow == 1 ? "取关" : "关注"
            Text(text)
                .textSett(color: "#FCCC46".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1, maxW: nil)
                .frame(width: 50, height: 24)
                .background("#FCCC46".color!.opacity(0.1))
                .cornerRadius(12)
                .onTapGesture {
                    if isFollow == 1 {
                        isFollow = 0
                        Task {
                            try await API.IM.attention(uidRels:[model.uid], status:0)
                        }
                    } else {
                        isFollow = 1
                        Task {
                            try await API.IM.attention(uidRels:[model.uid], status:1)
                        }
                    }
                }
        }
        .padding([.leading, .trailing], 15)
        .onAppear {
            Task {
                isFollow = try await API.IM.isAttention(userId: model.uid).data.isFollow
            }
        }
    }
}

struct RoomItem: View {
    var model: SearchRoomModel.ItemModel
    @State private var countModel: RoomViewersModel?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 108)
            .foregroundStyle(LinearGradient(stops: [.init(color: "#010209".color(alpha: 0.6)!, location: 0) , .init(color: "#1F265F".color(alpha: 0.6)!, location: 1)], startPoint: .leading, endPoint: .trailing))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(LinearGradient(colors: ["#FFFFFF".color(alpha: 0.0)!, "#FFFFFF".color(alpha: 0.6)!], startPoint: .leading, endPoint: .trailing))
                    .padding(0.5)
            }
            .overlay {
                HStack(spacing: 0) {
                    let url = URL(string: model.roomIcon)
                    CachedAsyncImage(url: url) { image in
                        image
                    } placeholder: {
                        "#1F265F".color(alpha: 0.6)!
                    }
                    .frame(width: 84, height: 84)
                    .cornerRadius(12, corners: .allCorners)
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(model.roomName)
                                .foregroundColor(.white)
                                .font(name: .PingFangSCSemibold, size: 16)
                            Text(String(format:"ID：%d", model.roomId))
                                .foregroundColor("FFFFFF".color(alpha: 0.7))
                                .font(name: .PingFangSCRegular, size: 12)
                                .padding(.top, 4)
                            //                                Image("jiaoyouicon")
                            //                                    .resizable().aspectRatio(contentMode: .fit)
                            //                                    .frame(height: 15)
                            //                                    .padding(.top, 2)
                            //                                    .hidden()
                            Spacer()
                            HStack(spacing: 0) {
                                Image("roomcellperson")
                                Text(String(format: "%d", countModel?.data.totalNum ?? 0))
                                    .foregroundColor("#FCCC46".color)
                                    .font(name: .PingFangSCRegular, size: 12)
                                    .padding(.leading, 6)
                                Text("人在线")
                                    .foregroundColor("#55586C".color)
                                    .font(name: .PingFangSCRegular, size: 12)
                                    .padding(.leading, 6)
                            }
                            .padding(.bottom, 12)
                        }
                        .padding([.leading, .top], 12)
                        
                        Spacer()
                        
//                        HStack(spacing: 0) {
//                            Image("chatroomxinhao").resizable().aspectRatio(contentMode: .fit)
//                                .frame(width: 12)
//
//                            Text("2516")
//                                .foregroundColor("#55586C".color)
//                                .font(name: .PingFangSCRegular, size: 12)
//                                .padding(.leading, 2)
//                        }
//                        .padding([.bottom, .trailing], 12)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 12)
            }
            .padding(.top, 13)
            .onAppear {
                Task {
                    self.countModel = try await API.Room.getRoomViewers(roomId: model.roomId)
                }
            }
    }
}

struct HomeSearch_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearch()
    }
}
