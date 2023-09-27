//
//  RankingList.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/19.
//

import SwiftUI
import Combine
import SwiftUITools

struct RankingList: View {
    
    @State private var rankingTypeSelection: RankingTypeSegment.RankingType = .meili
    @State private var rankingTimeSelection: RankingTimeSegment.RankingTimes = .ribang
    @State private var preselectedIndex = 0
    @State private var rankingModel: RankingListModel?
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(spacing: 0) {
                RankingTimeSegment(rankingTimeSelection: $rankingTimeSelection)
                    .padding(.top, 12)
                
                TopThreeView(factor: 1, rankingModel: $rankingModel)
                
                rankingList()
            }
            .frame(width: geo.size.width)
            .customBackView {
                Image("backArrow")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    RankingTypeSegment(rankingTypeSelection: $rankingTypeSelection)
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .background("#050017".color)
        .ignoresSafeArea(edges: .bottom)
        .topSafeAreaColor(color: "#050017".color)
        .onAppear {
            loadData()
        }
        .onChange(of: rankingTimeSelection) { newValue in
            loadData()
        }
        .onChange(of: rankingTypeSelection) { newValue in
            loadData()
        }
    }
    
    private func loadData() {
//        if let url = Bundle.main.url(forResource: "rankingList", withExtension: "json"),
//           let data = try? Data(contentsOf: url),
//           let model  = try? JSONDecoder().decode(RankingListModel.self, from: data) {
//            self.rankingModel = model
//        }
     
        let rtype = rankingTypeSelection == .meili ? "1" : "2"
        let type:String
        switch rankingTimeSelection {
        case .ribang: type = "2"
        case .zhoubang: type = "3"
        case .yuebang: type = "5"
        }
        API.Room.rankingList(rtype: rtype, type: type) { data, error in
            if let data = data,
               let model = try? JSONDecoder().decode(RankingListModel.self, from: data)
            {
                rankingModel = model
            }
        }
    }
    
    private func rankingList() -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    if let list = rankingModel?.data.list.dropFirst(3) {
                        ForEach(list.indices, id: \.self) { index in
                            listItem(index: index, model: list[index])
                        }
                    }
                }
            }
            .background(.white.opacity(0.1))
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .padding(.top, 18)
            .padding([.leading, .trailing], 16)
            Rectangle().fill("#191527".color!)
                .frame(height: 89)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .overlay {
                    if let info = rankingModel?.data.userInfo {
                        let itemM = ItemModel(avatar: info.avatar, gender: info.gender, nickName: info.nickName, userLevel: 0, charmNum: info.charmNum, age: info.age, uid: info.uid, differWithLastOne: "\(info.difference)", charmNumStr: "")
                        listItem(index: 0, model: itemM, onRank: info.onRank)
                    }
                }
        }
    }
    
    @ViewBuilder private func listItem(index: Int, model: ItemModel, onRank: Int? = nil) -> some View {
        HStack(spacing: 0) {
            let rank = onRank == nil ? "\(index+1)" : onRank == 0 ? "未上榜" : "\(onRank!)"
            Text("\(rank)")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 18, lineLi: 1, maxW: nil)
                .padding(.leading, 20)
            let url = URL(string: model.avatar)
            CachedAsyncImage(url: url, content: {image in
                image.resizable().scaledToFill()
            }, placeholder: {Color.gray})
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading, 20)
                .padding([.top, .bottom], 12)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(model.nickName)")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1, maxW: nil)
                if onRank == nil {
                    HStack(spacing:6) {
                        ZStack {
                            Capsule()
                                .fill("#FF72DC".color!)
                                .frame(width: 32, height: 14)
                            HStack (spacing: 1) {
                                let imageN = model.gender == .female ? "paihangnv":"rankingNan"
                                Image(imageN)
                                Text("\(model.age)")
                                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 11, lineLi: 1, maxW: nil)
                            }
                        }
                        BadgeView(level: model.userLevel, type: .level)
                    }
                }
            }
            .padding(.leading, 12)
            Spacer()
            VStack(spacing: 2) {
                Text(model.differWithLastOne)
                    .textSett(color: .white.opacity(0.6), FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                Text("距上一名")
                    .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 11, lineLi: 1, maxW: nil)
            }
            .padding(.trailing, 25)
        }

    }
}

struct TopThreeView: View {
    var factor: CGFloat
    @Binding var rankingModel: RankingListModel?
    
    var body: some View {
        if let list = rankingModel?.data.list.prefix(3) {
            HStack(spacing: 10*factor) {
                if list.count > 1 {
                    VStack(spacing: 0) {
                        Image("yajun").resizable().scaledToFit()
                            .frame(width: 80*factor, height: 84*factor)
                            .overlay {
                                let url = URL(string: list[1].avatar)
                                CachedAsyncImage(url: url, content: {image in
                                    image.resizable().scaledToFill()
                                }, placeholder: {Color.gray})
                                .frame(width: 57*factor, height: 57*factor)
                                .clipShape(Circle())
                            }
                        Text("\(list[1].nickName)")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 3)
                        BadgeView(level: list[1].userLevel, type: .level)
                            .padding(.top, 8)
                        Text(String(list[1].charmNumStr))
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 4)
                    }
                    .offset(y: 18)
                }
                if list.count > 0 {
                    VStack(spacing: 0) {
                        Image("guanjun").resizable().scaledToFit()
                            .frame(width: 91*factor, height: 95*factor)
                            .overlay {
                                let url = URL(string: list[0].avatar)
                                CachedAsyncImage(url: url, content: {image in
                                    image.resizable().scaledToFill()
                                }, placeholder: {Color.gray})
                                    .frame(width: 65*factor, height: 65*factor)
                                    .clipShape(Circle())
                                    .offset(y: -1)
                            }
                        Text("\(list[0].nickName)")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 3)
                        BadgeView(level: list[0].userLevel, type: .level)
                            .padding(.top, 8)
                        Text(String(list[0].charmNumStr))
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 4)
                    }
                }
                if list.count > 2 {
                    VStack(spacing: 0) {
                        Image("yajun").resizable().scaledToFit()
                            .frame(width: 80*factor, height: 84*factor)
                            .overlay {
                                let url = URL(string: list[2].avatar)
                                CachedAsyncImage(url: url, content: {image in
                                    image.resizable().scaledToFill()
                                }, placeholder: {Color.gray})
                                    .frame(width: 57*factor, height: 57*factor)
                                    .clipShape(Circle())
                            }
                        Text("\(list[2].nickName)")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 3)
                        BadgeView(level: list[2].userLevel, type: .level)
                            .padding(.top, 8)
                        Text(String(list[2].charmNumStr))
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1, maxW: nil)
                            .padding(.top, 4)
                    }
                    .offset(y: 18)
                }
            }
            .padding([.leading, .trailing], 10*factor)
            .padding(.top, 20)
        }
    }
}

struct RankingTypeSegment: View {
    enum RankingType: String, CaseIterable {
        case meili = "魅力榜"
        case caifu = "财富榜"
    }
    @Binding var rankingTypeSelection: RankingType
    let rankingTypeSelectionChange = PassthroughSubject<RankingType, Never>()
    @Namespace private var namespace1
    
    var body: some View {
        HStack(spacing: 36) {
            ForEach(RankingType.allCases, id:\.rawValue) { item in
                VStack(spacing: 6) {
                    let color = item == rankingTypeSelection ? Color.white : Color.white.opacity(0.6)
                    let fontN: CommonFontNames = item == rankingTypeSelection ? .PingFangSCMedium : .PingFangSCRegular
                    Text(item.rawValue)
                        .textSett(color: color, FName: fontN, Fsize: 17, lineLi: 1, maxW: nil)
                        .onTapGesture {
                            withAnimation {
                                rankingTypeSelection = item
                            }
                        }
                }
                .padding(.bottom, 10)
                .ifdo(item == rankingTypeSelection, transform: { view in
                    view.overlay(alignment: .bottom) {
                        Capsule()
                            .fill(.white)
                            .frame(width: 20, height: 4)
                            .matchedGeometryEffect(id: "rankingType", in: namespace1)
                    }
                })
            }
        }
    }
}

struct RankingTimeSegment: View {
    enum RankingTimes: String, CaseIterable {
        case ribang = "日榜"
        case zhoubang = "周榜"
        case yuebang = "月榜"
    }
    @Binding var rankingTimeSelection: RankingTimes
    @Namespace private var namespace2
    let rankingTimeSelectionChange = PassthroughSubject<RankingTimes, Never>()
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(RankingTimes.allCases, id: \.rawValue) { rankingTime in
                Text(rankingTime.rawValue)
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW:nil)
                    .frame(width: 66, height: 26)
                    .onTapGesture {
                        withAnimation {
                            rankingTimeSelection = rankingTime
                        }
                    }
                    .ifdo(rankingTime == rankingTimeSelection) { view in
                        view.background {
                            Capsule().fill(.white.opacity(0.2))
                                .frame(width: 66, height: 26)
                                .matchedGeometryEffect(id: "rankingTime", in: namespace2)
                        }
                    }
            }
        }
        .frame(height: 30)
        .background(.white.opacity(0.1))
        .cornerRadius(15)
    }
}


struct RankingList_Previews: PreviewProvider {
    static var previews: some View {
        RankingList()
    }
}
