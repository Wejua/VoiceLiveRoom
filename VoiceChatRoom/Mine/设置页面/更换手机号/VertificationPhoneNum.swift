//
//  VertificationPhoneNum.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/6/12.
//

import SwiftUI
import SwiftUITools

struct VertificationPhoneNum: View {
    var phoneNum: String
    @State var text: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerRemaining = 60
    @State var startTimer: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(phoneNum.prefix(3) + " **** " + phoneNum.suffix(4))
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 18, lineLi: nil)
                .padding(.top, 80)
            
            TextField("", text: $text, prompt: Text("请输入验证码").foregroundColor(captionColor))
                .TextFieldSett(textC: .white, cursorC: .white, fontN: .PingFangSCRegular, fontS: 15)
                .frame(height: 55)
                .padding(.leading, 25)
                .background(secondaryColor)
                .cornerRadius(55/2.0)
                .overlay(alignment: .trailing) {
                    Text("\(timerRemaining)s")
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                        .padding(.trailing, 20)
                        .onReceive(timer) { _ in
                            if timerRemaining > 0 {
                                timerRemaining -= 1
                            }
                        }
                }
                .padding([.leading, .trailing], 30)
                .padding(.top, 30)
            
            HStack(spacing: 0) {
                Text("收不到验证码？点击获取")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                Button {
                    API.Login.sendVerifyCode(phoneNum: phoneNum, smsType: 4, type: 2) { data, error in
                        if error == nil {
//                            startTimer = true
                        }
                    }
                } label: {
                    Text("语音验证码")
                        .textSett(color: "#2FC2FF".color!, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                }

            }
                .padding(.top, 92)
            Spacer()
        }
        .background(primaryColor)
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("验证新手机号"))
    }
}

struct VertificationPhoneNum_Previews: PreviewProvider {
    static var previews: some View {
        VertificationPhoneNum(phoneNum: "13241509397")
    }
}
