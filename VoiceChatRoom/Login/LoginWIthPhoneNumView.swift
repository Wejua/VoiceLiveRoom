//
//  LoginWIthPhoneNumView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI
import SwiftUITools

struct LoginWIthPhoneNumView: View {
    @State private var phoneNumber: String = ""
    @Binding var path: [OneClickLoginView.LoginViewDestiantion]
    @State var showToast: Bool = false
    @State var showError: Bool = false
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(alignment: .leading) {
                Text("手机号码登录")
                    .font(name: .PingFangSCSemibold, size: 24)
                    .foregroundColor(.white)
                    .navigationBarBackButtonHidden(true)
                    .customBackView(label: {
                        Image("backArrow")
                    })
                    .padding(.top, 158*factor)
                
                ZStack {
                    Capsule(style: .circular)
                        .fill("#282828FF".color!)
                        .frame(width: 280*factor, height: 52*factor)
                    HStack(spacing: 8*factor) {
                        Image("phoneImage")
                            .resizable()
                            .frame(width: 24*factor, height: 24*factor)
                        TextField("", text: $phoneNumber, prompt: Text("请输入手机号").foregroundColor("FFFFFF33".color))
                            .textFieldStyle(.plain)
                            .keyboardType(.numberPad)
                            .foregroundColor(.white)
                            .frame(width: 200*factor)
                            .accentColor(.white)
                            .font(name: .PingFangSCRegular, size: 18*factor)
                    }
                }
                .padding(.top, 60*factor)
                
                Button {
                    let regex = /^1\d{10}$/
                    if (phoneNumber.wholeMatch(of: regex) != nil) {
                        API.Login.sendVerifyCode(phoneNum: phoneNumber, smsType: 1, type: 1) { data, error in
                            if error == nil {
                                path.append(.vertificationCodeView(phoneNum: phoneNumber))
                            } else {
                                showError = true
                            }
                        }
                    } else {
                        showToast = true
                    }
                } label: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill("#FCCC46FF".color!)
                            .frame(width: 280*factor, height: 52*factor)
                        Text("获取验证码")
                            .font(name: .PingFangSCMedium, size: 16*factor)
                            .foregroundColor("#311D08FF".color)
                    }
                }
                .padding(.top, 91*factor)
                
                Spacer()

            }
            .frame(width: geo.size.width)
            .background("#050017FF".color)
            .ignoresSafeArea()
            .toast(message: "请输入正确的手机号", isShowing: $showToast, duration: 1.5)
            .toast(message: "获取验证码失败", isShowing: $showError, duration: 1.5)
        }
    }
}

struct LoginWIthPhoneNumView_Previews: PreviewProvider {
    static var previews: some View {
        LoginWIthPhoneNumView(path: .constant([OneClickLoginView.LoginViewDestiantion]()))
    }
}
