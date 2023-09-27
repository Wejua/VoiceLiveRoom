//
//  TabBarView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/15.
//

import SwiftUI
import SwiftUITools

struct TabBarView: View {
    @State private var currentTab: TabType = .chatRoom
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        NavigationStack(path: $store.navigationPath) {
            CustomTabView(selectedItem: $currentTab) {
                ChatRoomPageView()
                    .tabBarItem(item: .chatRoom, currentItem: $currentTab)
                RoomsView()
                    .tabBarItem(item: .rooms, currentItem: $currentTab)
                MessagePageView()
                    .tabBarItem(item: .messages, currentItem: $currentTab)
                MineView()
                    .tabBarItem(item: .mine, currentItem: $currentTab)
            }
            .navigationDestination(for: String.self) { str in
                if str == "postMoment" {
                    PostMomentView()
                } else if str == "momentDetail" {
                    MomentsDetail()
                } else if str == "roomMessageView" {
                    MessagesView(isRoomMessageView: true)
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
