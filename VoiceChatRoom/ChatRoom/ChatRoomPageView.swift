//
//  ChatRoomPageView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/14.
//

import SwiftUI
import SwiftUITools

class ChatRoomPageViewVM: ObservableObject {
    @Published var myRoomModel: MyRoomModel?
    
    init() {
        Task { @MainActor in
            self.myRoomModel = try await API.Account.getMyRoom()
        }
    }
}

struct ChatRoomPageView: View {
    enum PageType {
        case chatRoomView
        case momentsView
    }
    
    @State private var currentPage: PageType = .chatRoomView
    @State private var showRoomView: Bool = false
    @State private var minimize: Bool = false
    @StateObject var vm = ChatRoomPageViewVM()
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(spacing: 12*factor) {
                HStack(spacing: 16*factor) {
                    let chatRoom = Text("聊天室")
                        .foregroundColor(currentPage == .chatRoomView ? Color.white : "FFFFFF".color(alpha: 0.6))
                        .onTapGesture {
                            currentPage = .chatRoomView
                        }
                        .padding(.leading, 16*factor)
                    if currentPage == .chatRoomView {
                        chatRoom
                        .font(name: .PingFangSCSemibold, size: 18*factor)
                    } else {
                        chatRoom
                            .font(name: .PingFangSCRegular, size: 16*factor)
                    }
                    let moments = Text("动态")
                        .foregroundColor(currentPage == .momentsView ? Color.white : "FFFFFF".color(alpha: 0.6))
                        .onTapGesture {
                            currentPage = .momentsView
                        }
                    if currentPage == .momentsView {
                        moments
                            .font(name: .PingFangSCSemibold, size: 18*factor)
                    } else {
                        moments
                            .font(name: .PingFangSCRegular, size: 16*factor)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 25*factor) {
                        NavigationLink {
                            HomeSearch()
                        } label: {
                            Image("search")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24*factor)
                        }
                        
                        NavigationLink {
                            RankingList()
                        } label: {
                            Image("ranking")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24*factor)
                        }

                        if (vm.myRoomModel?.data.myRoom) != nil {
//                            NavigationLink {
//                                if let roomId = myRoomModel?.data.myRoom?.roomId {
//                                    RoomView(roomId: roomId, showRoomView: $showRoomView)
//                                }
//                            } label: {
                                Image("add")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24*factor)
                                    .onTapGesture(perform: {
                                        showRoomView.toggle()
                                    })
                                    .presentModal(isPresented: $showRoomView) {
                                        if let roomId = vm.myRoomModel?.data.myRoom?.roomId {
                                            RoomView(roomId: roomId, showRoomView: $showRoomView, minimize: $minimize)
                                        }
                                    }
//                            }
                        }
                    }
                    .padding(.trailing, 25*factor)
                }
                .padding(.top, geo.safeAreaInsets.top)
                TabView(selection: $currentPage) {
                    ChatRoomView()
                        .tag(ChatRoomPageView.PageType.chatRoomView)
                    MomentsView()
                        .tag(ChatRoomPageView.PageType.momentsView)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .padding(.bottom, 53)
            .background(Image("chatRoomBackground").resizable())
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .onAppear {
                
            }
        }
    }
}

struct ChatRoomPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomPageView()
    }
}
