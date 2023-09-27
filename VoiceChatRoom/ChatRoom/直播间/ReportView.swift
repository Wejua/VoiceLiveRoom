//
//  ReportView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/22.
//

import SwiftUI
import SwiftUITools

struct ReportView: View {
    private var reasons: [String] = ["色情低俗聊骚", "诈骗或垃圾信息", "隐私泄漏", "政治敏感", "暴力违法", "广告", "其他问题"]
    @State private var currentReason: String = "色情低俗聊骚"
    private let maxImageCount = 3
    @State private var images: [Image] = []
    @State private var text: String = ""
    @State private var enableOKButton: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Section {
                reportReasonView()
            } header: {
                Text("类型")
                    .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 15, lineLi: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 10, trailing: 0))
            }
            
            Section {
                pickImageView()
            } header: {
                HStack(spacing: 0) {
                    Text("上传证据截图")
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 15, lineLi: 1)
                    Text("(最多3张图片)")
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 15, lineLi: 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 40, leading: 15, bottom: 10, trailing: 0))
            }
            
            Section {
                reasonDetailContent()
            } header: {
                HStack(spacing: 0) {
                    Text("详细描述举报内容")
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 15, lineLi: 1)
                    Text("(必填)")
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 15, lineLi: 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 40, leading: 15, bottom: 10, trailing: 0))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    Capsule(style: .continuous)
                        .fill(enableOKButton ? "#FCCC46FF".color! : "#FCCC4688".color!)
                        .frame(width: 315, height: 49)
                    Text("提交")
                        .foregroundColor("#311D08FF".color)
                        .font(name: .PingFangSCMedium, size: 15)
                }
            }
            .padding(.top, 80)
            .disabled(!enableOKButton)
        }
        .customBackView {
            Image("backArrow")
        }
        .inlineNavigationTitle(title: Text("举报"))
        .background(primaryColor)
    }
    
    @ViewBuilder private func reasonDetailContent() -> some View {
        TextField("", text: $text, prompt: Text("说明原因").foregroundColor("FFFFFF".color(alpha: 0.3)), axis: .vertical)
            .font(name: .PingFangSCRegular, size: 14)
            .foregroundColor("ffffff".color)
            .tint(.white)
            .padding([.top, .leading], 12)
            .background("#1E1A2E".color(alpha: 0.5))
            .cornerRadius(12)
            .padding([.leading, .trailing], 16)
            .lineLimit(8, reservesSpace: true)
    }
    
    @ViewBuilder private func pickImageView() -> some View {
        let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        LazyVGrid(columns: gridItems, spacing: 12) {
            ForEach(images.indices, id:\.self) { index in
                PickOneImage {
                    images[index]
                        .resizable()
                        .cornerRadius(12)
                        .frame(width: 80, height: 80)
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
    }
    
    @ViewBuilder private func reportReasonView() -> some View {
        WrappingHStack(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
            ForEach(reasons, id: \.self) { string in
                let color = currentReason == string ? onTintColor : subTitleColor
                Text(string)
                    .textSett(color: color, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .ifdo(currentReason == string, transform: { view in
                        view.background(tintColor)
                            .cornerRadius(7, corners: .allCorners)
                    })
                    .ifdo(currentReason != string, transform: { view in
                        view.overlay {
                            RoundedRectangle(cornerRadius: 7, style: .circular)
                                .stroke(captionColor, style: SwiftUI.StrokeStyle(lineWidth: 1))
                        }
                    })
                    .onTapGesture {
                        currentReason = string
                    }
            }
        }
        .padding([.leading, .trailing], 10)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
