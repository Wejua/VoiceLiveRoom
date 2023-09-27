//
//  VideoMoment.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI
import SwiftUITools

struct VideoMoment: View {
    let factor: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MomentsHeader(factor: factor)
            VideoPlayer(videoURL: URL(string: "http://wbck.com"))
                .frame(width: 163*factor, height:238*factor)
                .overlay {
                    Color.gray
                }
                .cornerRadius(8*factor)
                .overlay {
                    Image("moment_play")
                }
                .padding(.top, 13*factor)
                .padding(.leading, 56*factor)
            
            MomentBottomView(factor: factor)
        }
    }
}

struct VideoMoment_Previews: PreviewProvider {
    static var previews: some View {
        VideoMoment(factor: 375)
            .background(.blue)
    }
}
