//
//  TwoSmallImageMoment.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI

struct TwoSmallImageMoment: View {
    let factor: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MomentsHeader(factor: factor)
            MomentMiddleText(factor: factor)
            HStack(spacing: 8*factor) {
                AsyncImage(url: nil) { image in
                    image
                } placeholder: {
                    Color.gray
                }
                .frame(width: 146.5*factor, height: 146.5*factor)
                .cornerRadius(6*factor)
                AsyncImage(url: nil) { image in
                    image
                } placeholder: {
                    Color.gray
                }
                .frame(width: 146.5*factor, height: 146.5*factor)
                .cornerRadius(6*factor)
            }
            .padding(.leading, 56*factor)
            MomentBottomView(factor: factor)
        }
    }
}

struct TwoSmallImageMoment_Previews: PreviewProvider {
    static var previews: some View {
        TwoSmallImageMoment(factor: 375)
            .background(.blue)
    }
}
