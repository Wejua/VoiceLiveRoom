//
//  OneClickLoginView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI
import SwiftUITools

struct OneClickLoginView: View {
    enum LoginViewDestiantion: Hashable {
        case loginWithPhoneNumView
        case loginWithPasswordView
        case vertificationCodeView(phoneNum: String)
        case basicPersonalInfoFillingView(userInfo: LoginOrRegisterModel.UserInfoModel)
    }
    
    @State private var showMyView: Bool = false
    @State private var isAgreementSelected: Bool = false
    @State private var showLoginWithPhoneNumView: Bool = false
    @State private var path: [LoginViewDestiantion] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            FitScreenMin(reference: 375.0) { factor, geo in
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 25.0, style: .circular)
                        .frame(width: 100, height: 100)
                        .foregroundColor("#FCCC46".color)
                    Text("135****2540")
                        .foregroundColor(.white)
                        .font(name: .PingFangSCSemibold, size: 22*factor)
                        .padding(.top, 60*factor)
                    Text("中国移动提供认证服务")
                        .font(name: .PingFangSCRegular, size: 14*factor)
                        .foregroundColor("FFFFFFAA".color)
                        .padding(.top, 9*factor)
                    Button {
                    } label: {
                        ZStack {
                            Capsule(style: .continuous)
                                .fill("#FCCC46".color!)
                                .frame(width: 280*factor, height: 52*factor)
                            Text("本机号码登录")
                                .font(name: .PingFangSCMedium, size: 16*factor)
                                .bold()
                                .foregroundColor("#311D08".color)
                        }
                    }
                    .padding(.top, 31*factor)
                    Button {
                        path.append(.loginWithPhoneNumView)
                    } label: {
                        ZStack {
                            Capsule(style: .continuous)
                                .fill("#282828".color!)
                                .frame(width: 280*factor, height: 52*factor)
                            Text("其他号码登录")
                                .font(name: .PingFangSCMedium, size: 16*factor)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 16*factor)
                    Button {
                        path.append(.loginWithPasswordView)
                    } label: {
                        Text("其他登录方式")
                            .font(name: .PingFangSCRegular, size: 12*factor)
                            .foregroundColor("FFFFFFAA".color)
                    }
                    .padding(.top, 102*factor)
//                    thirdPartyLoginView(factor: factor)
                    Button {
                        isAgreementSelected.toggle()
                    } label: {
                        HStack(spacing: 4*factor) {
                            if isAgreementSelected {
                                Image("agreement_selected")
                                    .resizable()
                                    .frame(width: 12*factor, height: 12*factor)
                            } else {
                                Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 1.0))
                                    .frame(width: 12*factor, height: 12*factor)
                                    .foregroundColor(.white)
                            }
                            Text("本人已阅读并同意《用户协议》和《隐私政策》")
                                .font(name: .PingFangSCRegular, size: 11*factor)
                                .accentColor("#FCCC46".color)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.top, 14*factor)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .background("#050017".color)
            .ignoresSafeArea()
            .navigationDestination(for: LoginViewDestiantion.self) { desti in
                switch desti {
                case .loginWithPhoneNumView:
                    LoginWIthPhoneNumView(path: $path)
                case .loginWithPasswordView:
                    PasswordLoginView()
                case .vertificationCodeView(let phoneNum):
                    VertificationCodeView(phoneNumber: phoneNum, path: $path)
                case .basicPersonalInfoFillingView(userInfo: let userInfo):
                    BasicPersonalInfoFillingView(userInfo: userInfo)
                }
            }
        }
    }
    
    private func thirdPartyLoginView(factor: CGFloat) -> some View {
        HStack(spacing: 18*factor) {
            Button {
            } label: {
                Image("IDLoginIcon")
                    .resizable()
                    .frame(width: 56*factor, height: 56*factor)
            }
            Button {
            } label: {
                Image("wechatLoginIcon")
                    .resizable()
                    .frame(width: 56*factor, height: 56*factor)
            }
            Button {
            } label: {
                Image("qqLoginIcon")
                    .resizable()
                    .frame(width: 56*factor, height: 56*factor)
            }
            Button {
            } label: {
                Image("appleLoginIcon")
                    .resizable()
                    .frame(width: 56*factor, height: 56*factor)
            }
        }
        .padding(.top, 31*factor)
    }
}

struct OneClickLoginView_Previews: PreviewProvider {
    static var previews: some View {
        OneClickLoginView()
//            .frame(width: 375/1.0, height: 812/1.0)
    }
}
