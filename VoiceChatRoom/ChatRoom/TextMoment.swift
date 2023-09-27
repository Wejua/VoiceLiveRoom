//
//  TextMoment.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI

struct TextMoment: View {
    let factor: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MomentsHeader(factor: factor)
            MomentMiddleText(factor: factor)
            MomentBottomView(factor: factor)
        }
    }
}

struct TextMoment_Previews: PreviewProvider {
    static var previews: some View {
        TextMoment(factor: 375)
            .background(.blue)
    }
}
