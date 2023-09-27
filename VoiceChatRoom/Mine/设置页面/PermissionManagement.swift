//
//  PermissionManagement.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI

struct PermissionManagement: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("为保障产品和功能的使用，本软件会向你申请手机系统权限，以下常用权限可以在这里操作管理")
                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 6.5)
            
            itemView(title: "位置权限", isAllowed: false)
            itemView(title: "相机", isAllowed: true)
            itemView(title: "相册", isAllowed: true)
            itemView(title: "麦克风", isAllowed: true)
            itemView(title: "通知权限", isAllowed: true)
            
            Text("你可以在[《权限说明》](www.a.com)中了解到权限的详细应")
                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding([.leading, .trailing], 16)
            
            Spacer()
        }
        .inlineNavigationTitle(title: Text("系统权限管理"))
        .customBackView {
            Image("backArrow")
        }
        .background(primaryColor)
        .topSafeAreaColor(color: secondaryColor)
    }
    
    @ViewBuilder private func itemView(title: String, isAllowed: Bool) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            Spacer()
            let title = isAllowed ? "允许访问" : "未允许访问"
            let color = isAllowed ? captionColor : tintColor
            Text(title)
                .textSett(color: color, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            Image("mine_rightArrow")
                .padding(.leading, 6.5)
        }
        .padding(16)
        .background(secondaryColor)
    }
}

struct PermissionManagement_Previews: PreviewProvider {
    static var previews: some View {
        PermissionManagement()
    }
}
