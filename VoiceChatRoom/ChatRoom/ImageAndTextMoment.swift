//
//  ImageAndTextMoment.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI

struct ImageAndTextMoment: View {
    let factor: CGFloat
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            MomentsHeader(factor: factor)
            
            MomentMiddleText(factor: factor)
            
            HStack(spacing: 8*factor) {
                AsyncImage(url: nil) { image in
                    image
                } placeholder: {
                    Color.gray
                }
                .frame(width: 190*factor, height: 215*factor)
                .cornerRadius(12*factor)
                VStack(spacing: 9*factor) {
                    AsyncImage(url: nil, content: {image in image}, placeholder: {Color.gray})
                        .frame(width: 103*factor, height: 103*factor)
                        .cornerRadius(12*factor)
                    AsyncImage(url: nil, content: {image in image}, placeholder: {Color.gray})
                        .frame(width: 103*factor, height: 103*factor)
                        .cornerRadius(12*factor)
                }
            }
            .padding(.leading, 58*factor)
            
            MomentBottomView(factor: factor)
        }
    }
}

struct MomentMiddleText: View {
    let factor: CGFloat
    
    var body: some View {
        Text("卑微玩家局，只爱前任不钓鱼卑微玩家局")
            .foregroundColor(.white)
            .font(name: .PingFangSCRegular, size: 14*factor)
            .lineLimit(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 13*factor)
            .padding(.trailing, 16*factor)
            .padding(.leading, 58*factor)
            .padding(.bottom, 12*factor)
    }
}

struct MomentBottomView: View {
    var factor: CGFloat
    
    var body: some View {
        HStack(spacing: 16*factor) {
            Spacer()
            HStack(spacing: 2*factor) {
                Image("moment_zan")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22*factor)
                Text("999")
                    .foregroundColor("#93949D".color)
                    .font(name: .PingFangSCRegular, size: 11*factor)
            }
            HStack(spacing: 2*factor) {
                Image("momentComment")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22*factor)
                Text("999")
                    .foregroundColor("#93949D".color)
                    .font(name: .PingFangSCRegular, size: 11*factor)
            }
        }
        .padding([.top, .trailing, .bottom], 16*factor)
    }
}

struct ImageAndTextMoment_Previews: PreviewProvider {
    static var previews: some View {
        ImageAndTextMoment(factor: 375)
            .background(.blue)
    }
}
