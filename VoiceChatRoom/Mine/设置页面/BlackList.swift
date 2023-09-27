//
//  BlackList.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI
import SwiftUITools

struct BlackList: View {
    @State var users: [BlackUserModel] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(users, id: \.uidRel) { user in
                    itemView(image: user.avatar, title: user.username, gender: user.gender, age: user.age, uid: user.uidRel)
                }
            }
        }
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("黑名单"))
        .onAppear {
            Task {
                users = try await API.IM.blackList(page: 1)
            }
        }
    }
    
    @ViewBuilder private func itemView(image: String, title: String, gender: Gender, age: Int, uid: Int) -> some View {
        HStack(spacing: 0) {
            let url = URL(string: image)
            CachedAsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                placeHolderColor
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                AgeView(gender: gender, age: age)
            }
            .padding(.leading, 14)
            
            Spacer()
            
            Text("移除")
                .textSett(color: tintColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: nil)
                .frame(width: 70, height: 26)
                .background(tintBackground)
                .cornerRadius(13)
                .onTapGesture {
                    Task {
                        let result = try await API.IM.blockUser(buid: uid, status: 0)
                        if result {
                            users = users.filter{$0.uidRel != uid}
                        }
                    }
                }
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 15)
    }
}

struct BlackList_Previews: PreviewProvider {
    static var previews: some View {
        BlackList()
    }
}
