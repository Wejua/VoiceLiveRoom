//
//  MomentsHeader.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI

struct MomentsHeader: View {
    let factor: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            MomentHeaderLeft(factor: factor)
            
            Spacer()
            
            Image("header_sayhello")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 22*factor)
                .padding(.trailing, 8*factor)
            Image("header_more")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 22*factor)
                .padding(.trailing, 16*factor)
        }
        .padding([.top, .leading], 16*factor)
    }
}

struct MomentHeaderLeft: View {
    var factor: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: nil) { image in
                image
            } placeholder: {
                Color.gray
            }
            .frame(width: 34*factor, height: 34*factor)
            .clipShape(Circle())
            .overlay(alignment: .bottomTrailing) {
                Image("header_gender_girl")
            }
            
            VStack(alignment:.leading, spacing: 4) {
                Text("阿升不会迟到")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(name: .PingFangSCMedium, size: 14*factor)
                HStack(spacing: 0) {
                    Text("刚刚发布")
                        .foregroundColor("#93949D".color)
                        .font(name: .PingFangSCRegular, size: 12*factor)
                    Image("headerLocation")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12*factor)
                        .padding(.leading, 6*factor)
                    Text("金华市")
                        .foregroundColor("#93949D".color)
                        .font(name: .PingFangSCRegular, size: 12*factor)
                        .padding(.leading, 2*factor)
                }
            }
            .padding(.leading, 8*factor)
        }
    }
}

struct MomentsHeader_Previews: PreviewProvider {
    static var previews: some View {
        MomentsHeader(factor: 1)
            .background("#050017".color)
    }
}
