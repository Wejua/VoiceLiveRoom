//
//  About.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI

struct About: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Image("")
                    .frame(width: 80, height: 80)
                    .background(.gray)
                    .cornerRadius(16)
                Text("appname")
                    .textSett(color: subTitleColor, FName: .PingFangSCMedium, Fsize: 17, lineLi: nil)
            }
            .padding([.top, .bottom], 51)
            
            let titles = ["当前版本", "用户协议", "隐私政策"]
            ForEach(titles, id: \.self) { title in
                HStack(spacing: 0) {
                    Text(title)
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                    Spacer()
                    if title == "当前版本" {
                        Text("V.3.1.0")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                    }
                    Image("mine_rightArrow")
                        .padding(.leading, 6.5)
                }
                .padding(16)
                .background(secondaryColor)
            }
            
            Spacer()
        }
        .background(primaryColor)
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("关于我们"))
        .topSafeAreaColor(color: secondaryColor)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
