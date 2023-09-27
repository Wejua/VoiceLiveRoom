//
//  MomentsDetail.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/17.
//

import SwiftUI
import SwiftUITools

struct MomentsDetail: View {
    @State private var text: String = ""
    @State private var imageSelection: String = "a"
    @State private var imageUrls: [String] = ["a", "b", "c"]
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            ZStack {
                "#050017".color.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            detailInfoView(factor: factor)
                            ForEach(0..<10, id: \.self) { _ in
                                CommentView(factor: factor)
                            }
                        }
                    }
                }
                .customBackView {
                    Image("backArrow")
                }
                .navigationTitle("动态详情")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("header_more")
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    TextField("", text: $text, prompt: Text("说点什么…").foregroundColor("ffffff".color(alpha: 0.5)))
                        .font(name: .PingFangSCRegular, size: 14*factor)
                        .tint(.white)
                        .foregroundColor(.white)
                        .frame(height: 36*factor)
                        .padding(.leading, 16*factor)
                        .background("#474352".color)
                        .cornerRadius(7*factor)
                        .padding([.leading, .trailing], 16*factor)
                }
            }
        }
    }
    
    @ViewBuilder private func detailInfoView(factor: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                MomentHeaderLeft(factor: factor)
                Spacer()
                Text("关注")
                    .foregroundColor(.white)
                    .font(name: .PingFangSCMedium, size: 13*factor)
                    .frame(width: 55*factor, height: 24*factor)
                    .background("#1D141B".color)
                    .cornerRadius(12*factor)
                    .onTapGesture {
                    }
                    .padding(.trailing, 16*factor)
            }
            .padding([.top, .leading], 16*factor)
            
            Text("卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼卑微玩家痴情局，只爱前任不钓鱼")
                .foregroundColor(.white)
                .font(name: .PingFangSCRegular, size: 14*factor)
                .padding(.top, 14*factor)
                .padding([ .trailing], 16*factor)
                .padding(.leading, 56*factor)
            
            TabView(selection: $imageSelection) {
                ForEach(imageUrls, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .tag(url)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 215*factor)
            .cornerRadius(6*factor)
            .overlay(alignment: .bottom) {
                IndexView(factor: factor, selections: imageUrls, currentSelection: $imageSelection)
                    .padding(.bottom, 8*factor)
            }
            .padding(.trailing, 16*factor)
            .padding(.leading, 56*factor)
            .padding(.top, 12*factor)
            
            HStack(spacing: 0) {
                Spacer()
                ForEach(0..<8, id: \.self) { _ in
                    AsyncImage(url: nil) { image in
                        image
                            .resizable().scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 22*factor, height: 22*factor)
                    .clipShape(Circle())
                    .overlay {
                        Circle().strokeBorder(.white, lineWidth: 0.5 )
                    }
                }
                Spacer()
            }
            .padding(.top, 16*factor)
            
            HStack(spacing: 4*factor) {
                Spacer()
                Image("xuanzhongRight")
                Text("共36人点赞")
                    .foregroundColor("ffffff".color(alpha: 0.6))
                    .font(name: .PingFangSCRegular, size: 12*factor)
                Image("xuanzhongLeft")
                Spacer()
            }
            .padding(.top, 10*factor)
            
            HStack {
                Spacer()
                Image("zan_unselected")
                    .resizable().scaledToFit()
                    .frame(width: 25*factor)
                    .padding(.top, 11*factor)
                Spacer()
            }
            
            Rectangle().fill("#191527".color!)
                .frame(height: 6)
                .padding(.top, 16*factor)
            
            Text("评论(3)")
                .foregroundColor(.white)
                .font(name: .PingFangSCMedium, size: 14*factor)
                .padding(.top, 8*factor)
                .padding(.leading, 16*factor)
        }
    }
}

struct IndexView: View {
    var factor: CGFloat
    var selections: [String]
    @Binding var currentSelection: String
//    @Namespace var indexViewNamespace
    
    var body: some View {
        HStack(spacing: 5*factor) {
            ForEach(selections, id: \.self) { selection in
                if selection == currentSelection {
                    Capsule()
                        .fill("FFFFFF".color!)
                        .frame(width: 15*factor, height: 4*factor)
                } else {
                    Capsule()
                        .fill("#FFFFFF".color(alpha: 0.5)!)
                        .frame(width: 8*factor, height: 4*factor)
                }
            }
        }
//        .matchedGeometryEffect(id: "size", in: indexViewNamespace)
    }
}

struct CommentView: View {
    var factor: CGFloat
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            AsyncImage(url: nil) { image in
                image
                    .resizable().scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 34*factor, height: 34*factor)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 0) {
                Text("糖果超咸")
                    .foregroundColor(.white)
                    .font(name: .PingFangSCMedium, size: 14*factor)
                Text("1天前")
                    .foregroundColor("#A4A6A9".color)
                    .font(name: .PingFangHKRegular, size: 10*factor)
                    .padding(.top, 4*factor)
                
                Text("你的生活我的梦，梦回故里还是你！测试测试你的生活我的梦，梦回故里还是你！测试测试")
                    .foregroundColor("#616161".color)
                    .font(name: .PingFangHKRegular, size: 13*factor)
                    .padding(.top, 10*factor)
            }
            .padding(.leading, 8*factor)
            
            Spacer()
        }
        .padding(.leading, 24*factor)
        .padding(.trailing, 16*factor)
        .padding(.top, 12*factor)
        .padding(.bottom, 20*factor)
    }
}

struct MomentsDetail_Previews: PreviewProvider {
    static var previews: some View {
        MomentsDetail()
            .background("#050017".color)
    }
}
