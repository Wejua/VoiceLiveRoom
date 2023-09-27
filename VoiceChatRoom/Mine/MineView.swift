//
//  MineView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/15.
//

import SwiftUI
import SwiftUITools

class MineAssetsModel: ObservableObject, Codable {
    var data: AssetsModel
    
    class AssetsModel: ObservableObject, Codable {
        var assetsDiamond: AssetsDiamondModel
        var assetsCoinU: AssetsCoinUModel
    }
    
    class AssetsDiamondModel: ObservableObject, Codable {
        var balance: String
    }
    
    class AssetsCoinUModel: ObservableObject, Codable {
        var balance: String
    }
}

struct MineView: View {
    @State private var isLoadingData: Bool = false
    @State private var balanceModel: MineAssetsModel?
    @State private var userInfoModel: UserInfoModel?
    @State private var gradeModel: UserGradeInfoModel?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("mine_beijing").resizable().scaledToFit()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        profileEntryView(model: userInfoModel)
                            .padding(.top, 36)
                    }
                    .padding([.leading, .trailing], 15)
                    
                    LevelsView(model: $gradeModel)
                        .padding(.top, 24)
                        .padding([.leading, .trailing], 15)
                    
                    NavigationLink {
                        WalletView()
                    } label: {
                        balanceView()
                    }
                    
                    othersView()
                    
                    Spacer()
                }
            }
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image("mine_setting")
                    }
                }
            }
            .onAppear {
                if !isLoadingData {
                    isLoadingData = true
                    API.Account.getBalance { data, error in
                        if let data = data,
                           let model = try? JSONDecoder().decode(MineAssetsModel.self, from: data)
                        {
                            balanceModel = model
                        }
                    }
                    Task {
                        self.userInfoModel = try await API.Account.getMyInfo()
                        guard let uid = self.userInfoModel?.data.basic.userId else {return}
                        self.gradeModel = try await API.Account.getGradesInfo(uid: uid)
                    }
                }
            }
        }
    }
    
    private func profileEntryView(model: UserInfoModel?) -> some View {
        HStack(spacing: 0) {
            let url = URL(string: model?.data.basic.currentAvatar ?? "")
            CachedAsyncImage(url: url, content: {
                $0
                    .resizable().scaledToFill()
            }, placeholder: {Color.gray})
                .frame(width: 62, height: 62)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .strokeBorder(style: .init(lineWidth: 1))
                        .foregroundColor(.white)
                }
            VStack(alignment: .leading, spacing: 0) {
                Text("\(model?.data.basic.userName ?? "--")")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 18, lineLi: 1)
                HStack(spacing: 4) {
                    Text(String(format:"ID:%d", model?.data.basic.userId ?? 0))
                        .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        .padding(.top, 2)
                    Image("roomcopy")
                }
                .onTapGesture {
                    UIPasteboard.general.string = String(format:"ID:%d", model?.data.basic.userId ?? 0)
                }
            }
            .padding(.leading, 10)
            Spacer()
            Image("rightArrow")
        }

    }
    
    private func balanceView() -> some View {
        Image("yuebeijing").resizable().scaledToFit()
            .padding([.leading, .trailing], 15)
            .padding(.top, 12)
            .overlay {
                HStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("\(balanceModel?.data.assetsDiamond.balance ?? "0")")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 26, lineLi: 1)
                        HStack(spacing: 4) {
                            Text("钻石余额")
                                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                            Image("zhuanshi")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 12) {
                        Text("\(balanceModel?.data.assetsCoinU.balance ?? "0")")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 26, lineLi: 1)
                        HStack(spacing: 4) {
                            Text("金币余额")
                                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                            Image("caifudengji")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
    }
    
    private func othersView() -> some View {
        Color.white.opacity(0.1)
            .frame(height: 82)
            .cornerRadius(10, corners: .allCorners)
            .overlay {
                HStack(spacing: 0) {
//                            Spacer()
                    VStack(spacing: 3) {
                        Image("wodezhaungban")
                        Text("我的装扮")
                            .textSett(color: "#6A6A71".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 3) {
                        Image("zhuangbanshangcheng")
                        Text("装扮商城")
                            .textSett(color: "#6A6A71".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 3) {
                        Image("guizutequan")
                        Text("贵族特权")
                            .textSett(color: "#6A6A71".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 3) {
                        Image("kefubangzhu")
                        Text("客服帮助")
                            .textSett(color: "#6A6A71".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .padding([.leading, .trailing], 15)
    }
}

struct LevelsView: View {
    @Binding var model: UserGradeInfoModel?
    
    var body: some View {
        HStack(spacing: 6) {
            Color.white.opacity(0.1)
                .frame(height: 80)
                .cornerRadius(12, corners: .allCorners)
                .overlay {
                    VStack(spacing: 0) {
                        Text("M.\(model?.data.charmGrade ?? 0)")
                            .textSett(color: "#A16CF7".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("mine_meilidengji")
                        Text("魅力等级")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                }
            //                    Spacer()
            Color.white.opacity(0.1)
                .frame(height: 80)
                .cornerRadius(12, corners: .allCorners)
                .overlay {
                    VStack(spacing: 0) {
                        Text("LV.\(model?.data.richesGrade ?? 0)")
                            .textSett(color: "#FF7815".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("mine_caifudengji")
                        Text("财富等级")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                }
            //                    Spacer()
            Color.white.opacity(0.1)
                .frame(height: 80)
                .cornerRadius(12, corners: .allCorners)
                .overlay {
                    VStack(spacing: 0) {
                        Text("黄金\(model?.data.roomMedalGrade ?? 0)")
                            .textSett(color: "#FC30A0".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("mine_fangjianxunzhang")
                        Text("房间勋章")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                }
        }
    }
}

struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}
