//
//  PasswordLoginView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI
import SwiftUITools

struct PasswordLoginView: View {
    @State private var accountString: String = ""
    @State private var passwordString: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(alignment: .leading, spacing: 0) {
                Text("账号密码登录")
                    .foregroundColor(.white)
                    .font(name: .PingFangSCSemibold, size: 24*factor)
                    .padding(.top, 158*factor)
                
                accountTextField(factor: factor)
                    .padding(.top, 60*factor)
                
                VStack(alignment: .trailing) {
                    passwordTextField(factor: factor)
                        .padding(.top, 24*factor)
                    
                    Button {
                        //忘记密码
                    } label: {
                        Text("忘记密码")
                            .foregroundColor("FFFFFFBB".color)
                            .font(name: .PingFangSCRegular, size: 14*factor)
                            .padding(.top, 12*factor)
                            .padding(.trailing, 13*factor)
                    }
                }

                Button {
                    
                } label: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill("#FCCC46FF".color!)
                            .frame(width: 280*factor, height: 52*factor)
                        
                        Text("登录")
                            .foregroundColor("#311D08FF".color)
                        .font(name: .PingFangSCMedium, size: 16)
                    }
                }
                .padding(.top, 88*factor)
                
                Spacer()
            }
            .frame(width: geo.size.width)
            .background("#050017FF".color)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("backArrow")
                    }
                    
                }
            }
        }
    }
    
    private func accountTextField(factor: CGFloat) -> some View {
        ZStack {
            Capsule(style: .continuous)
                .fill("#282828FF".color!)
                .frame(width: 280*factor, height: 52*factor)
                .cornerRadius(34.5*factor, corners: .allCorners)
            TextField("", text: $accountString, prompt:
                        Text("请输入手机号")
                .foregroundColor("FFFFFF33".color)
            )
            .foregroundColor(.white)
            .tint(.white)
            .frame(width: 265, height: 48*factor)
            .font(name: .PingFangSCMedium, size: 16*factor)
//            .background(.red)
        }
    }
    
    private func passwordTextField(factor: CGFloat) -> some View {
        ZStack(alignment: .trailing) {
            ZStack {
                Capsule(style: .continuous)
                    .fill("#282828FF".color!)
                    .frame(width: 280*factor, height: 52*factor)
                    .cornerRadius(34.5*factor, corners: .allCorners)
                TextField("", text: $passwordString, prompt:
                            Text("请输入密码")
                    .foregroundColor("FFFFFF33".color)
                )
                .foregroundColor(.white)
                .tint(.white)
                .frame(width: 235, height: 48*factor)
                .font(name: .PingFangSCMedium, size: 16*factor)
                //            .background(.red)
            }
            
            Image("eyeIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24*factor)
                .padding(.trailing, 16*factor)
        }
    }
}

struct PasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLoginView()
    }
}
