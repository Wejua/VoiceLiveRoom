//
//  RoomGiftViewGiftType.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/7.
//

import SwiftUI

struct RoomGiftViewGiftType: View {
    enum SegmentType: String, CaseIterable {
        case putong = "普通"
        case baoxiang = "宝箱"
        case xingyun = "幸运"
        case guizu = "贵族"
    }
    @State private var currentType: SegmentType = .putong
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(SegmentType.allCases, id: \.rawValue) { type in
                let color = type == currentType ? .white : "#AFB2BF".color!
                Text(type.rawValue)
                    .textSett(color: color, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                    .frame(width: 40, height: 22)
                    .ifdo(currentType == type) { view in
                        view.background {
                            Capsule().fill(.white.opacity(0.2))
                                .matchedGeometryEffect(id: "back", in: namespace)
                        }
                    }
                    .onTapGesture {
                        currentType = type
                    }
                    .animation(.easeInOut(duration: 0.3), value: currentType)
            }
        }
    }
}

struct RoomGiftViewGiftType_Previews: PreviewProvider {
    static var previews: some View {
        RoomGiftViewGiftType()
    }
}
