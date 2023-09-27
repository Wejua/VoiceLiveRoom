//
//  GiftListViewSegmentView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/7.
//

import SwiftUI

struct GiftListViewSegmentView: View {
    enum SegmentType: String {
        case liwu = "礼物"
        case beibao = "背包"
    }
    private let types: [SegmentType] = [SegmentType.liwu, SegmentType.beibao]
    @State private var currentType: SegmentType = .liwu
    @Namespace var namespace 
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(types, id:\.rawValue) { type in
                let color = type == currentType ? .white : "#AFB2BF".color!
                Text(type.rawValue)
                    .textSett(color: color, FName: .PingFangSCMedium, Fsize: 14, lineLi: nil)
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 2.5)
                    .onTapGesture(perform: {
                        currentType = type
                    })
                    .ifdo(currentType == type) { view in
                        view.overlay(alignment: .bottom) {
                            Capsule()
                                .fill(.white)
                                .frame(width: 10, height: 2.5)
                                .matchedGeometryEffect(id: "segment", in: namespace)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: currentType)
            }
        }
    }
}

struct GiftListViewSegmentView_Previews: PreviewProvider {
    static var previews: some View {
        GiftListViewSegmentView()
    }
}
