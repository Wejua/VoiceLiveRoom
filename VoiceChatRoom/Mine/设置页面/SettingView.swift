//
//  SettingView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI

struct SettingView: View {
    enum Title: String, CaseIterable {
        case accountSecurity = "帐号安全"
        case blackList = "黑名单"
        case cleanCache = "清理缓存空间"
        case systemPermission = "系统权限管理"
        case giveAGoodReview = "亲，给个好评吧"
        case about = "关于我们"
        case signOut = "退出当前帐号"
    }
    @State var showSignOutAlert: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Title.allCases, id: \.rawValue) { title in
                    if title == .giveAGoodReview {
                        rawItemView(title: title.rawValue, detail: nil)
                            .onTapGesture {
                                
                            }
                    } else if title == .signOut {
                        rawItemView(title: title.rawValue, detail: nil)
                            .onTapGesture {
                                showSignOutAlert.toggle()
                            }
                    } else {
                        let detail = title == .cleanCache ? "88MB" : nil
                        itemView(title: title.rawValue, detail: detail, destination: destination(title: title))
                    }
                }
            }
        }
        .background(primaryColor)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .customBackView {
            Image("backArrow")
        }
        .topSafeAreaColor(color: secondaryColor)
        .alert("确定退出当前账号吗？", isPresented: $showSignOutAlert) {
            Button("确定", role: .destructive) {
                Store.shared.loginOut()
            }
            Button("取消", role: .cancel) {}
        }
    }
    
    @ViewBuilder private func destination(title: Title) -> some View {
        if title == .accountSecurity {
            AccountSecurity()
        } else if title == .blackList {
            BlackList()
        } else if title == .cleanCache {
            CacheClean()
        } else if title == .systemPermission {
            PermissionManagement()
        } else if title == .about {
            About()
        }
    }
    
    @ViewBuilder private func itemView(title: String, detail: String?, destination: some View) -> some View {
        NavigationLink {
            destination
        } label: {
            rawItemView(title: title, detail: detail)
        }
    }
    
    @ViewBuilder func rawItemView(title: String, detail: String?) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: 1)
            Spacer()
            if let detail = detail {
                Text(detail)
                    .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
            }
            Image("mine_rightArrow")
                .padding(.leading, 6.5)
        }
        .padding(16)
        .background(secondaryColor)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
