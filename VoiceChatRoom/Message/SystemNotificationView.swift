//
//  SystemNotificationView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/8.
//

import SwiftUI

struct SystemNotificationView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            scrollView()
            customServiceAndFAQ()
        }
        .background(primaryColor)
        .customBackView {
            Image("backArrow")
        }
        .navigationTitle("系统通知")
        .navigationBarTitleDisplayMode(.inline)
//        .topSafeAreaColor(color: .white)
//        .bottomSafeAreaColor(color: .white)
//        .preferredColorScheme(.light)
    }
    
    @ViewBuilder private func customServiceAndFAQ() -> some View {
        let contents: [(image: Image, title: String)] = [(Image("lianxikefu"), "联系客服"), (Image("changjianwenti"), "常见问题")]
        LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 2)) {
            ForEach(contents, id:\.title) { content in
                HStack(spacing: 5) {
                    content.image
                    Text(content.title)
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                }
                .padding([.top, .bottom], 15)
            }
        }
        .background(primaryColor)
    }
    
    @ViewBuilder private func scrollView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(0..<1, id: \.self) { _ in
                    checkInView()
                }
                ForEach(0..<1, id: \.self) { _ in
                    approvedView()
                }
                ForEach(0..<1, id: \.self) { _ in
                    approvedView2()
                }
                ForEach(0..<1, id: \.self) { _ in
                    receivedGiftView()
                }
                ForEach(0..<1, id: \.self) { _ in
                    dynamicApproving(content: "您的动态 “非常厉害的天气，怎么可以...”已审核通过，有趣的内容能拉近你和TA的距离~")
                }
                ForEach(0..<1, id: \.self) { _ in
                    dynamicApproving(content: "您的动态 [图片] 已审核通过，有趣的内容能拉近你和TA的距离~")
                }
                ForEach(0..<1, id: \.self) { _ in
                    dynamicApproving(content: "您的评论 “非常厉害的天气，怎么可以...”已审核通过，有趣的内容能拉近你和TA的距离~")
                }
            }
            .padding(.bottom, 19.5)
        }
    }
    
    @ViewBuilder private func dynamicApproving(content: LocalizedStringKey) -> some View {
        baseView(title: "动态审核") {
            VStack(spacing: 0) {
                Text(content)
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Rectangle().fill(tertiaryColor)
                    .frame(height: 0.5)
                    .padding(.top, 10)
                HStack(spacing: 0) {
                    Text("[前往查看](www.a.com)")
                        .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tint(tintColor)
                    Image("noti_more_arrow")
                }
                .padding(.top, 4)
            }
            .padding([.top, .leading, .trailing], 15)
            .padding(.bottom, 9.5)
        }
    }
    
    @ViewBuilder private func receivedGiftView() -> some View {
        baseView(title: "恭喜！你刚收到[XXXX](www.baidu.com)赠送的礼物") {
            VStack(spacing: 10) {
                Text("礼物名字*1，获得了X星光")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("[查看我的收益](www.a.com)")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("真人认证后被搭讪和收益翻倍，[立刻去认证](www.b.com)")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(15)
        }
    }
    
    @ViewBuilder private func approvedView2() -> some View {
        baseView(title: "恭喜，你的真人认证已通过审核！") {
            VStack(spacing: 10) {
                Text("[完善个人资料](www.baidu.com)领取红包")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("[上传4张靓照](www.baidu.com)领取红包")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("[提交真人认证](www.baidu.com)后收益提升200%")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(15)
        }
    }
    
    @ViewBuilder private func approvedView() -> some View {
        baseView(title: "恭喜，你的真人认证已通过审核！") {
            VStack(spacing: 0) {
                Text("上传更多靓照，会吸引更多小哥哥哦！")
                    .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 15)
                    .padding(.top, 10)
                Rectangle().fill(tertiaryColor)
                    .frame(height: 0.5)
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 15)
                HStack(spacing: 0) {
                    Text("完善个人资料，领取红包")
                        .textSett(color: tintColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                    Spacer()
                    Image("noti_more_arrow")
                }
                .padding(.top, 4)
                .padding(.leading, 15)
                .padding(.trailing, 10)
                .padding(.bottom, 9.5)
            }
        }
    }
    
    @ViewBuilder private func checkInView() -> some View {
        baseView(title: "签到成功！") {
            Text("恭喜！签到第一天送XU币，明天签到送XU币")
                .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .bottom], 15)
                .padding(.top, 10)
        }
    }
    
    @ViewBuilder private func baseView(title: LocalizedStringKey, anotherContent: () -> some View) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image("notificationIcon")
            VStack(spacing: 0) {
                Text(title)
                    .textSett(color: titleColor, FName: .PingFangSCMedium, Fsize: 15, lineLi: nil)
                    .tint(tintColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 15)
                anotherContent()
            }
            .background(secondaryColor)
            .cornerRadius(10)
        }
        .padding([.top, .leading], 15)
        .padding(.trailing, 20)
    }
}

struct SystemNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        SystemNotificationView()
    }
}
