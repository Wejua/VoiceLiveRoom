//
//  ProfileView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/23.
//

import SwiftUI
import SwiftUITools

struct ProfileView: View {
    @State var isAttention: Bool = false
    @State private var isLoadedData: Bool = false
    @State private var userInfoModel: UserInfoModel?
    @State private var userGradeModel: UserGradeInfoModel?
    @State private var giftsWallModel: GiftsListModel?
    @State private var giftsWallModel2: GiftsListModel?
    @State private var seatsModel: SeatsModel?
    
    var body: some View {
        ZStack(alignment: .top) {
            CachedAsyncImage(url: URL(string: userInfoModel?.data.basic.currentAvatar ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                "#050017".color!
            }

            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        basicInfo()
                        Text("等级")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1)
                            .frame(height: 46)
                            .padding(.top, 12)
                        LevelsView(model: $userGradeModel)
                            .padding(.top, 12)
                        seatsView()
                            .padding(.top, 12)
                        giftsView()
                            .padding(.top, 12)
                            .padding(.bottom, 24)
                        attentionAndMessageView()
                            .padding([.top, .bottom], 12)
                    }
                    .padding([.leading, .trailing], 16)
                    .background("#050017".color)
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                    
                    HStack(spacing: 0) {
                        let url = URL(string: userInfoModel?.data.basic.portraitUrl ?? "")
                        CachedAsyncImage(url: url, content: {
                            $0.resizable().scaledToFill()
                        }, placeholder: {
                            placeHolderColor
                        })
                            .frame(width: 82, height: 82)
                            .clipShape(Circle())
                            .overlay {
                                Circle().strokeBorder("#050017".color!, lineWidth: 2)
                            }
                            .offset(y: -41)
                            .padding(.leading, 24)
                        Spacer()
                    }
                }
                .overlay(alignment: .topTrailing, content: {
                    ZStack {
                        Image("diwangbadge_bottom")
//                            .padding(.top, 6)
                        VStack(spacing: 0) {
                            Image("diwangbadge")
                                .offset(y: -6)
//                                .background(.blue)
                            HStack(spacing: 0) {
                                Text("帝王")
                                    .textSett(color: "#FCCC46".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                                Image("diwang(2)")
                            }
                            .offset(y: -8)
//                            .background(.red)
                        }
                    }
                    .padding(.top, 66)
                    .padding(.trailing, 17)
                })
                .padding(.top, 280)
            }
            .onAppear {
                Task {
                    if isLoadedData == false {
                        isLoadedData = true
                        let userInfoModel = try await API.Account.getMyInfo()
                        let uid = userInfoModel.data.basic.userId
                        self.userInfoModel = userInfoModel
                        try await getOtherInfo(uid: uid)
                    }
                }
            }
        }
        .customBackView {
            Image("backArrow")
        }
        .ignoresSafeArea(edges: .top)
    }
    
    @MainActor
    private func getOtherInfo(uid: Int) async throws {
        async let gradeModel = API.Account.getGradesInfo(uid: uid)
        async let giftsWallModel = API.Account.giftsList(giftType: 0, page: 1, tagUid: uid)
        async let giftsWallModel2 = API.Account.giftsList(giftType: 2, page: 1, tagUid: uid)
        async let seatsModel = API.Account.getSeats(targetId: uid, page: 1)
        self.userGradeModel = try await gradeModel
        self.giftsWallModel = try await giftsWallModel
        self.giftsWallModel2 = try await giftsWallModel2
        self.seatsModel = try await seatsModel
    }
    
    @ViewBuilder private func attentionAndMessageView() -> some View {
        let color = isAttention ? "#FCCC46".color! : "#CBCEDC".color!
        HStack(spacing: 0) {
            Spacer()
            HStack(spacing: 6) {
                Image("guanzhu")
                Text("关注")
                    .textSett(color: color, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .cornerRadius(22)
            .overlay {
                Capsule().strokeBorder(color, lineWidth: 0.5)
            }
            .onTapGesture {
                if let uid = userInfoModel?.data.basic.userId {
                    Task {
                        try await API.IM.attention(uidRels: [uid], status: 1)
                    }
                }
            }
            Spacer()
            HStack(spacing: 6) {
                Image("sixin")
                Text("私信")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14, lineLi: 1)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background("#FCCC46".color)
            .cornerRadius(22)
        }
    }
    
    @ViewBuilder private func basicInfo() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Text("\(userInfoModel?.data.basic.userName ?? "--")")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 24, lineLi: 1)
                HStack(spacing: 3) {
                    Image("paihangnv")
                    Text("\(userInfoModel?.data.basic.age ?? 0)")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                }
                .frame(width: 38, height: 18)
                .background(content: {
                    LinearGradient(colors: ["#5FE5FD".color!, "#31C7F9".color!], startPoint: .leading, endPoint: .trailing)
                })
                .cornerRadius(9)
                
                Spacer()
            }
            .padding(.top, 60)
            
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(String(format: "ID:%d", userInfoModel?.data.basic.userId ?? 0))
                        .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    Image("roomcopy")
                        .padding(.leading, 4)
                }
                .onTapGesture {
                    UIPasteboard.general.string = String(format: "%d", userInfoModel?.data.basic.userId ?? 0)
                }
                Text("粉丝: \(userInfoModel?.data.relationCount.fansNum ?? 0)")
                    .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    .padding(.leading, 16)
            }
            HStack(spacing: 8) {
                BadgeView(level: userGradeModel?.data.charmGrade ?? 0, type: .badge)
                BadgeView(level: userGradeModel?.data.richesGrade ?? 0, type: .level)
            }
            .padding(.top, 12)
            Text("\(userInfoModel?.data.basic.slogan ?? "")")
                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                .padding(.top, 12)
            Text("个人信息")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1)
                .frame(height: 46)
                .padding(.top, 16)
            
            Text("星座：\(userInfoModel?.data.basic.horoscope ?? "--")")
                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
            Text("家乡：\(userInfoModel?.data.basic.address ?? "--")")
                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                .padding(.top, 12)
        }
    }
    
    @ViewBuilder private func seatsView() -> some View {
        VStack(spacing: 0) {
            Text("座驾")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1)
                .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 0) {
                        Text("查看")
                            .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("mine_rightArrow")
                    }
                }
            let columns = [GridItem](repeating: GridItem(.flexible(), spacing: 33), count: 3)
            LazyVGrid(columns: columns, spacing: 0) {
                let models = seatsModel?.data.prefix(3) ?? []
                ForEach(models, id:\.propId) { model in
                    ZStack {
                        Image("liwubackground").resizable().scaledToFit()
                            .overlay {
                                CachedAsyncImage(url: URL(string: model.coverImage)) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Color.clear
                                }
                                .padding(10)
                            }
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func giftsView() -> some View {
        VStack(spacing: 0) {
            Text("礼物墙")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1)
                .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 0) {
                        let lightNum = giftsWallModel?.data.lightNum ?? 0  + (giftsWallModel2?.data.lightNum ?? 0)
                        Text("已点亮\(lightNum)")
                            .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("mine_rightArrow")
                    }
                }
            let columns = [GridItem](repeating: GridItem(.flexible(), spacing: 33), count: 3)
            LazyVGrid(columns: columns, spacing: 12) {
                let gifts = giftsWallModel?.data.giftList ?? [] + (giftsWallModel2?.data.giftList ?? [])
                ForEach(gifts, id:\.id) { model in
                    VStack(spacing: 6) {
                        Image("liwubackground").resizable().scaledToFit()
                            .overlay {
                                let url = URL(string: model.icon)
                                CachedAsyncImage(url: url) { image in
                                    image.image?.resizable().scaledToFit()
                                }
                                .padding(10)
                            }
                        Text("\(model.name)")
                            .textSett(color: "#CBCEDC".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                }
            }
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
