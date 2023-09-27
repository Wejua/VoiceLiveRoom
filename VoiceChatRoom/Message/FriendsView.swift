//
//  FriendsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/22.
//

import SwiftUI

struct BadgeView: View {
    enum BadgeType {
        case badge
        case level
    }
    var level: Int
    var type: BadgeType
    var imageView: some View {
        if (1 <= level && level <= 9) {
            return type == .badge ? Image("M1_9") : Image("Lv1_9")
        } else if ( 10 <= level && level <= 19) {
            return type == .badge ? Image("M10_19") :  Image("Lv10_19")
        } else if ( 20 <= level && level <= 29) {
            return type == .badge ? Image("M20_29") : Image("Lv20_29")
        } else if ( 30 <= level && level <= 39) {
            return type == .badge ? Image("M30_39") : Image("Lv30_39")
        } else if ( 40 <= level && level <= 49) {
            return type == .badge ? Image("M40_49") : Image("Lv40_49")
        } else if ( 50 <= level && level <= 59) {
            return type == .badge ? Image("M50_59") : Image("Lv50_59")
        } else {
            return type == .badge ? Image("M60_69")  : Image("Lv60_69")
        }
    }
    var levelString: String {
        var level: String
        if 1 <= self.level && self.level <= 9 {
            level = "0\(self.level)"
        } else {
            level = "\(self.level)"
        }
        return level
    }
    
    var body: some View {
        imageView
            .overlay(alignment: .trailing) {
                let text = type == .badge ? "M.\(levelString)" : "Lv.\(levelString)"
                Text(text)
                    .textSett(color: .white, FName: .HelveticaBold, Fsize: 9, lineLi: 1)
                    .padding(.trailing, type == .badge ? 4 : 2)
            }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(level: 69, type: .level)
    }
}

struct FriendsView: View {
    enum Tab: String, CaseIterable {
        case haoyou = "好友"
        case guanzhu = "关注"
        case fensi = "粉丝"
    }
    
    @State private var currentTab: Tab = .haoyou
    @State private var fansModel: FansListModel?
    @State private var friendsModel: FriendsListModel?
    @State private var followingModel: AttentionListModel?
    @State private var showedItems: [FriendsListModel.DataModel] = []
    @State private var isLoadedData: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            segmentView()
                .padding(.leading, 16)
                .padding(.top, 16)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(showedItems, id:\.uidRel) { model in
                        friendCell(model: model)
                    }
                }
            }
            .background {
                if (showedItems.count == 0) {
                    NoDataView()
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 53)
        }
        .onAppear {
            if isLoadedData == false {
                isLoadedData = true
                Task {
                    async let fansModel = API.IM.fansList(keyWord: nil, page: 1, type: 0)
                    async let friendsModel = API.IM.friendsList(keyWord: nil, page: 1, type: 0)
                    async let followingModel = API.IM.attentionList(keyWord: nil, page: 1)
                    self.fansModel = try await fansModel
                    self.friendsModel = try await friendsModel
                    self.followingModel = try await followingModel
                }
            }
        }
    }
    
    private func segmentView() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id:\.rawValue) { tab in
                Text(tab.rawValue)
                    .textSett(color: currentTab == tab ? "#FCCC46".color! : .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1)
                    .frame(width: 60, height: 28)
                    .ifdo(tab == currentTab) { view in
                        view.background("#FCCC46".color!.opacity(0.1))
                            .cornerRadius(14, corners: .allCorners)
                    }
                    .onTapGesture {
                        currentTab = tab
                        switch currentTab {
                        case .haoyou:
                            showedItems = friendsModel?.data ?? []
                        case .guanzhu:
                            showedItems = followingModel?.data ?? []
                        case .fensi:
                            showedItems = fansModel?.data ?? []
                        }
                    }
            }
            Spacer()
        }
    }
    
    private func friendCell(model: FriendsListModel.DataModel) -> some View {
        HStack(spacing: 0) {
            AsyncImage(url: nil, content: {$0}, placeholder: {Color.gray})
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading, 15)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(model.username)")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1)
                HStack(spacing: 6) {
                    BadgeView(level: 69, type: .badge)
                    BadgeView(level: 51, type: .level)
                }
            }
            .padding(.leading, 10)
            Spacer()
            Text("取关")
                .textSett(color: "#FCCC46".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                .frame(width: 50, height: 24)
                .background("#FCCC46".color!.opacity(0.1))
                .cornerRadius(12, corners: .allCorners)
                .onTapGesture {
                    Task {
                        try await API.IM.attention(uidRels: [model.uidRel], status: 0)
                    }
                }
        }
        .frame(height: 74)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
