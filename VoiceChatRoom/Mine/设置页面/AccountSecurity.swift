//
//  AccountSecurity.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI

struct AccountSecurity: View {
    var body: some View {
        VStack {
            NavigationLink {
                ChangePhoneNumView()
            } label: {
                HStack(spacing: 0) {
                    Text("手机号")
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                    Spacer()
                    Text("152****0906")
                        .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                    Image("mine_rightArrow")
                        .padding(.leading, 6.5)
                }
                .padding(16)
            }

            
            HStack(spacing: 0) {
                Text("密码")
                    .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                Spacer()
                Text("去设置")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                Image("mine_rightArrow")
                    .padding(.leading, 6.5)
            }
            .padding(16)
            //暂时去掉绑定微信
//            HStack(spacing: 0) {
//                Text("微信")
//                    .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
//                Spacer()
//                Text("绑定")
//                    .textSett(color: tintColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
//                    .frame(width: 55, height: 26)
//                    .background(tintBackground)
//                    .cornerRadius(13)
//            }
//            .padding(16)
            
            Spacer()
        }
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("账号安全"))
    }
}

struct AccountSecurity_Previews: PreviewProvider {
    static var previews: some View {
        AccountSecurity()
    }
}
