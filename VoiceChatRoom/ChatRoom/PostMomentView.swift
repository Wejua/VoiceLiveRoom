//
//  PostMomentView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/16.
//

import SwiftUI
import SwiftUITools

struct PostMomentView: View {
    private let maxImageCount = 3
    @State private var images: [Image] = []
    @State private var text: String = ""
//    @State private var showImagePicker: Bool = false
//    @State private var selectedImage: UIImage?
    
    var body: some View {
        FitScreenMin(reference:375) { factor, geo in
            ZStack {
                "#050017".color
                    .ignoresSafeArea()
                
                let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                VStack(alignment: .leading, spacing: 0) {
                    LazyVGrid(columns: gridItems, spacing: 12) {
                        ForEach(images.indices, id:\.self) { index in
                            PickOneImage {
                                images[index]
                                    .resizable()
                                    .cornerRadius(12*factor)
                                    .frame(height: (geo.size.width-32-12)/3.0)
                            } completion: { image in
                                images[index] = Image(uiImage: image)
                            }
                        }
                        if images.count < maxImageCount {
                            PickImage(maxImageCount: maxImageCount-images.count) {
                                Image("addImageButton")
                            } completion: { images in
                                self.images.append(contentsOf: images)
                            }

                        }
                    }
                    .padding([.leading, .trailing], 16)
                    
                    TextField("", text: $text, prompt: Text("我想说").foregroundColor("FFFFFF".color(alpha: 0.3)), axis: .vertical)
                        .font(name: .PingFangSCRegular, size: 14)
                        .foregroundColor("ffffff".color)
                        .tint(.white)
                        .padding([.top, .leading], 12)
                        .background("#1E1A2E".color(alpha: 0.5))
                        .cornerRadius(12)
                        .padding(.top, 30)
                        .padding([.leading, .trailing], 16)
                        .lineLimit(8, reservesSpace: true)
                    
                    Spacer()
                }
                .safeAreaInset(edge: .bottom, content: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill("#FCCC46".color!)
                            .frame(width: 280, height: 52)
                        Text("确认发布")
                            .foregroundColor("#311D08".color)
                            .font(name: .PingFangSCMedium, size: 16)
                    }
                    .padding(.bottom, 12)
                })
            }
        }
        .navigationTitle("发动态")
        .navigationBarTitleDisplayMode(.inline)
        .customBackView {
            Image("backArrow")
        }
    }
}

struct PostMomentView_Previews: PreviewProvider {
    static var previews: some View {
        PostMomentView()
            .background("#050017".color)
    }
}

