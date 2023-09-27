//
//  ChangePhoneNumView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/6/12.
//

import SwiftUI
import SwiftUITools

struct ChangePhoneNumView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            let fontN = CommonFontNames.PingFangSCMedium
            Text("输入新手机号")
                .textSett(color: .white, FName: fontN, Fsize: 18, lineLi: nil)
                .padding(.top, 80)
            TextField("", text: $text, prompt: Text("请输入手机号").foregroundColor(captionColor))
                .TextFieldSett(textC: .white, cursorC: .white, fontN: CommonFontNames.PingFangSCRegular, fontS: 15)
                .keyboardType(.numberPad)
                .padding(.leading, 86)
                .frame(height: 55)
                .background(secondaryColor)
                .cornerRadius(55/2.0)
                .overlay(alignment: .leading){
                    HStack(spacing: 3.5) {
                        Text("+86")
                            .textSett(color: "6D7278".color!, FName: .PingFangSCRegular, Fsize: 18, lineLi: nil)
                        Image("changePhoneNum_arrow")
                    }
                    .padding(.leading, 20)
                }
                .padding([.leading, .trailing], 30)
                .padding(.top, 30)
            Spacer()
        }
        .background(primaryColor)
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("更换手机号"))
    }
}

struct ChangePhoneNumView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhoneNumView()
    }
}
