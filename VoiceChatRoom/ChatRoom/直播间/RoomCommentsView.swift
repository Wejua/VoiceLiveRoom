//
//  RoomCommentsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/24.
//

import SwiftUI
import RongIMLib

extension RoomView {
    @ViewBuilder func commentsView(messages: [RCMessage]?) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                if let announcement = enterRoomModel?.data.announcement {
                    Text("文明公告:" + announcement)
                        .foregroundColor("#FCCC46".color)
                        .font(name: .PingFangHKRegular, size: 12)
                        .frame(maxWidth: 262, alignment: .leading)
                        .padding(8)
                        .background("#000000".color(alpha: 0.32))
                        .cornerRadius(12)
                        .padding(.leading, 12)
                        .padding(.top, 12)
                }
                
//                ForEach(messages ?? [], id: \.messageId) {msg in
//                    msg.content
//                }
                
                roomCommentGreet()
                    .padding(.top, 12)
                roomCommentGift()
                    .padding(.top, 12)
                roomCommentView()
                    .padding(.top, 12)
            }
        }
    }
    
    private func roomCommentGreet() -> some View {
        ZStack {
            "#000000".color(alpha: 0.32)
            HStack(spacing: 6) {
                Image("xinrenbadge")
                Text("王鹿晗")
                    .foregroundColor(.white)
                    .font(name: .PingFangHKRegular, size: 11)
                Text("来了")
                    .foregroundColor("ffffff".color(alpha: 0.5))
                    .font(name: .PingFangHKRegular, size: 11)
            }
        }
        .cornerRadius(6)
        .frame(width: 98, height: 27)
        .padding(.leading, 12)
    }
    
    @ViewBuilder private func roomCommentGift() -> some View {
        VStack(alignment: .leading, spacing: 0) {
           roomCommentHeader()
            HStack(spacing: 4) {
                Text("送给")
                    .foregroundColor(.white)
                    .font(name: .PingFangSCRegular, size: 12)
                Text("计划是否…")
                    .foregroundColor("#FFBD24".color)
                    .font(name: .PingFangSCRegular, size: 12)
                Text("么么哒")
                    .foregroundColor(.white)
                    .font(name: .PingFangSCMedium, size: 12)
                Image("")
                Text("x10")
                    .foregroundColor("#FFBD24".color)
                    .font(name: .PingFangSCMedium, size: 12)
            }
            .padding(8)
            .background("#000000".color(alpha: 0.32))
            .cornerRadius(8)
            .padding(.top, 4)
            .padding(.leading, 28)
        }
    }
    
    private func roomCommentView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            roomCommentHeader()
            Text("你说你好看，他也说你好看，我说你真好看")
                .foregroundColor(.white)
                .font(name: .PingFangSCRegular, size: 12)
                .padding(8)
                .background("000000".color(alpha: 0.32))
                .cornerRadius(8)
                .padding(.top, 4)
                .padding(.leading, 28)
        }
    }
    
    private func roomCommentHeader() -> some View {
        HStack(spacing: 6) {
            AsyncImage(url: nil) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 22, height: 22)
            .clipShape(Circle())
            
            Image("levelBadge(1)")
            
            Text("草莓喵喵🌹")
                .foregroundColor(.white)
                .font(name: .PingFangSCRegular, size: 11)
        }
        .padding(.leading, 12)
    }
}
