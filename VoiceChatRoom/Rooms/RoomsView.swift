//
//  RoomsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/15.
//

import SwiftUI

struct RoomsView: View {
    private var images = ["roomsxindong", "roomsyouxi", "roomsjiaoyou", "roomschangge", "roomsdiantai", "roomslianmai"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("分类")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 18, lineLi: 1, maxW: nil)
                    .padding([.top, .bottom], 10)
                    .padding(.leading, 16)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                let items = [GridItem](repeating: GridItem(.flexible(), spacing: 12), count: 2)
                LazyVGrid(columns: items, spacing: 12) {
                    ForEach(images.indices, id: \.self) { index in
                        NavigationLink {
                            RoomView(roomId: index > 3 ? -2 : -3, showRoomView: .constant(false), minimize: .constant(false))
                        } label: {
                            Image(images[index]).resizable().scaledToFit()
                        }
                    }
                }
                .padding([.leading, .trailing, .bottom], 16)
            }
        }
        .padding(.bottom, 53)
        .background("#050017".color)
        .topSafeAreaColor(color: "#050017".color)
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView()
    }
}
