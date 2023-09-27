//
//  RoomViewSheets.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/24.
//

import SwiftUI
import SwiftUITools

extension RoomView {
    
    @ViewBuilder func sheets() -> some View {
        Sheet(edge: .top, isShowing: $showMore) {
            roomTopSheet()
        }
        
        Sheet(edge: .bottom, isShowing: $showRoomMemberList) {
            roomMemberListSheet()
        }
        .ignoresSafeArea()
        
        Sheet(edge: .bottom, isShowing: $showMemberInfo) {
            memberInfoSheet()
        }
        .ignoresSafeArea()
        
        Sheet(edge: .bottom, isShowing: $showGiftList) {
            GiftListView()
        }
    }
    
    @ViewBuilder func roomMemberListSheet() -> some View {
        VStack(alignment: .leading) {
            Text("房间成员（共\(membersModel?.data.count ?? 0)人）")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW: nil)
                .padding(.top, 16)
                .padding(.leading, 12)
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 20, pinnedViews: .sectionHeaders) {
                    ForEach(membersModel?.data ?? [], id: \.uid) { member in
                        HStack(spacing: 7) {
                            ZStack {
                                let url = URL(string: member.avatar ?? "")
                                AsyncImage(url: url, content: {$0}, placeholder: {Color.gray})
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            .frame(width: 62, height: 62)
                            VStack(alignment: .leading, spacing: 7) {
                                Text("\(member.nickName ?? "")")
                                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW: nil)
                                HStack(spacing: 2) {
                                    Image("header_gender_girl")
                                    Text("\(member.age ?? 0)岁·摩羯座")
                                        .textSett(color: "FFFFFF".color!.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1, maxW: nil)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 12)
                    }
                }
            }
        }
        .frame(height: 458)
        .background("#242138".color)
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder func roomTopSheet() -> some View {
        HStack(spacing: 80) {
            if isRoomOwner {
                Image("huanfangzhu")
            } else {
                Image("roomreportbutton")
                    .onTapGesture {
                        showMore.toggle()
                        showReportView.toggle()
                    }
            }
            Image("zuixiaohua")
                .onTapGesture {
//                    showRoomView = false
                    dismiss()
                    minimize = true
                }
            Image("roomexit")
                .onTapGesture {
                    dismiss()
//                    showRoomView.toggle()
                }
        }
        .padding(.top, 62)
    }
    
    @ViewBuilder func memberInfoSheet() -> some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        showReportView.toggle()
                    } label: {
                        VStack(spacing: 2) {
                            Image("roombottomreport")
                            Text("举报")
                                .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 11, lineLi: 1, maxW: nil)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.top, 14)
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("ID:90989799")
                            .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1, maxW: nil)
                        Image("roomcopy")
                    }
                    .padding(.top, 17)
                    .padding(.trailing, 19)
                }
                
                Spacer()
                Rectangle().fill(.white.opacity(0.15))
                    .frame(height: 1)
                HStack(spacing: 0) {
                    Text("+关注")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW: nil)
                        .frame(width: 62, height: 34)
                    Spacer()
                    Text("私聊")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW: nil)
                        .frame(width: 62, height: 34)
                    Spacer()
                    Text("送礼")
                        .textSett(color: "#FCCC46".color!, FName: .PingFangSCRegular, Fsize: 16, lineLi: 1, maxW: nil)
                        .frame(width: 62, height: 34)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12).strokeBorder(style: .init(lineWidth: 1))
                                .foregroundColor("#FCCC46".color)
                        }
                }
                .padding(.leading, 35)
                .padding(.trailing, 35)
                .padding(.bottom, 48)
                .padding(.top, 10)
            }
            .frame(height: 279)
            .background("#242138".color)
            .cornerRadius(24, corners: [.topLeft, .topRight])
            
            VStack(spacing: 0) {
                Image("摘星兔头像框")
                    .resizable().scaledToFit()
                    .frame(width: 111, height: 111)
                HStack(spacing: 0) {
                    Text("小彩虹🌈")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 18, lineLi: 1, maxW: nil)
                    Image("header_gender_girl")
                }
                .padding(.top, 12)
                HStack(spacing: 4) {
                    Image("levelBadge")
                    Image("usergrade")
                        .offset(y: 1)
                    Image("ouxiangdengji")
                }
                .padding(.top, 10)
                Text("这个人很懒，还没有留下签名～")
                    .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 14, lineLi: 1, maxW: nil)
                    .padding(.top, 13)
            }
            .offset(y: -111/2.0)
        }
    }
}
