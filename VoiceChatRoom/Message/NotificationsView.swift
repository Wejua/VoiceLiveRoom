//
//  NotificationsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/8.
//

import SwiftUI
import SwiftUITools

enum NotificationType: Codable {
    case text
    case video
    case image
}

struct NotificationsView: View {
    @State private var selectedSegment: Int = 0
    let thumbsupModels = [
        ThumbsupCellModel(headimage: "", username: "噜噜酱", age: 18, time: "2", commentedImage: "", gender: .female, id: 1, type: .text),
        ThumbsupCellModel(headimage: "", username: "name2", age: 29, time: "5", commentedImage: "", gender: .male, id: 2, type: .image)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CapsuleSegmentView(titles: ["全部", "点赞", "评论", "@我"], titleFontSize: 14, itemSize: CGSize(width: 50, height: 30), selectedIndex: $selectedSegment)
                .padding(.leading, 15)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(thumbsupModels, id:\.id) { model in
                        ThumbsupCell(model: model)
                    }
                    ForEach(0..<2, id:\.self) { _ in
                        CommentCell()
                    }
//                    ForEach(0..<2, id:\.self) { _ in
//
//                    }
                }
            }
        }
        .customBackView {
            Image("backArrow")
        }
        .navigationTitle("动态通知")
        .navigationBarTitleDisplayMode(.inline)
        .background(primaryColor)
    }
}

class ThumbsupCellModel: Codable, ObservableObject {
    var headimage: String
    var username: String
    var age: Int
    var time: String
    var commentedImage: String
    var gender: Gender
    var id: Int
    var type: NotificationType
    
    init(headimage: String, username: String, age: Int, time: String, commentedImage: String, gender: Gender, id: Int, type: NotificationType) {
        self.headimage = headimage
        self.username = username
        self.age = age
        self.time = time
        self.commentedImage = commentedImage
        self.gender = gender
        self.id = id
        self.type = type
    }
}

struct ThumbsupCell: View {
    @ObservedObject var model: ThumbsupCellModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                //headimage
                let url = URL(string: model.headimage)
                CachedAsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeHolderColor
                }
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .padding([.leading], 15)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        //username
                        Text(model.username)
                            .textSett(color: titleColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: 1)
                        
                        //age and gender
                        AgeView(gender: model.gender, age: model.age)
                            .padding(.leading, 4)
                        
                        Text("赞了我的动态")
                            .textSett(color: captionColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: 1)
                            .padding(.leading, 10)
                    }
                    
                    //like image
                    Image("notificationView_like")
                        .padding([.top, .bottom], 10)
                    
                    //time
                    Text("\(model.time)分钟前")
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 10, lineLi: 1)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                BeCommentContent(type: model.type)
            }
            .padding(.top, 15)
            
            Rectangle().fill(tertiaryColor)
                .frame(height: 0.5)
                .padding([.leading, .trailing], 15)
        }
    }
}

struct BeCommentContent: View {
    var type: NotificationType
    var imageUrl: String?
    var text: String? = "心小了，所有小事就大了"
    var videoUrl: String?
    
    var body: some View {
        switch type {
        case .image:
            CachedAsyncImage(url: URL(string: imageUrl ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                placeHolderColor
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .padding(.trailing, 15)
            .padding(.bottom, 26)
            
        case .text:
            Text(text ?? "")
                .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                .padding(4)
                .frame(width: 60, height: 60)
                .background(secondaryColor)
                .cornerRadius(8)
                .padding(.trailing, 15)
                .padding(.bottom, 26)
        case .video:
            VideoPlayer(videoURL: URL(string: videoUrl ?? ""))
                .frame(width: 60, height: 60)
                .overlay(alignment: .bottomLeading, content: {
                    Image("notification_videoIcon")
                        .padding([.leading, .bottom], 5)
                })
                .cornerRadius(8)
                .padding(.trailing, 15)
                .padding(.bottom, 26)
        }
    }
}

struct CommentCell: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                //headimage
                let url = URL(string: "")
                CachedAsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeHolderColor
                }
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .padding([.leading], 15)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        //username
                        Text("name")
                            .textSett(color: titleColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: 1)
                        
                        //age and gender
                        AgeView(gender: .female, age: 89)
                            .padding(.leading, 4)
                        
                        Text("评论了我的动态")
                            .textSett(color: captionColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: 1)
                            .padding(.leading, 10)
                    }
                    
                    Text("村上春树说：“如果一直想见谁 肯定能见到”，但下一句“所见之日便是")
                        .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                    
                    //time
                    Text("10小时前")
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 10, lineLi: 1)
                        .padding(.top, 10)
                    
                    //回复，赞
                    ReplyAndThumbsupView(isThumbsup: false)
                        .padding(.top, 10)
                }
                .padding(.leading, 10)
                .padding(.bottom, 15)
                
                
                BeCommentContent(type: .image, imageUrl: "")
            }
            .padding(.top, 15)
            
            Rectangle().fill(tertiaryColor)
                .frame(height: 0.5)
                .padding([.leading, .trailing], 15)
        }
    }
}

struct ReplyAndThumbsupView: View {
    var isThumbsup: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Text("回复")
                .textSett(color: tintColor, FName: .PingFangSCMedium, Fsize: 12, lineLi: nil)
                .frame(width: 50, height: 27)
                .overlay {
                    RoundedRectangle(cornerRadius: 13.5)
                        .stroke(tintColor, style: StrokeStyle(lineWidth: 1.5))
                }
            
            let color  = isThumbsup ? captionColor : tintColor
            let text = isThumbsup ? "已赞" : "赞"
            Text(text)
                .textSett(color: color, FName: .PingFangSCMedium, Fsize: 12, lineLi: nil)
                .frame(width: 50, height: 27)
                .overlay {
                    RoundedRectangle(cornerRadius: 13.5)
                        .stroke(color, style: StrokeStyle(lineWidth: 1.5))
                }
        }
    }
}

struct AgeView: View {
    var gender: Gender
    var age: Int
    
    var body: some View {
        HStack(spacing: 0) {
            let tintColor = gender == .female ? "#FF488D".color! : "#0DACFF".color!
            Image(gender == .female ? "paihangnv" : "rankingNan")
                .renderingMode(.template)
                .resizable().scaledToFit()
                .foregroundColor(tintColor)
                .padding([.top, .bottom], 1.5)
            Text("\(age)")
                .textSett(color: tintColor, FName: .PingFangSCSemibold, Fsize: 10, lineLi: nil)
                .padding(.leading, 1.5)
        }
        .frame(width: 31, height: 14)
        .background(gender == .female ? "#FF488D".color!.opacity(0.4) : "#0DACFF".color!.opacity(0.4))
        .cornerRadius(7)
    }
}

struct CapsuleSegmentView: View {
    var titles: [String]
    var titleFontSize: CGFloat
    var itemSize: CGSize
    @Binding var selectedIndex: Int
    @Namespace private var namespace
    
    var body: some View {
        let selectedColor = "#FCCC46".color!
        HStack(spacing: 5) {
            ForEach(titles.indices, id:\.self) {index in
                Text(titles[index])
                    .textSett(color: index == selectedIndex ? selectedColor : .white, FName: .PingFangSCMedium, Fsize: titleFontSize, lineLi: nil)
                    .frame(width: itemSize.width, height: itemSize.height)
                    .onTapGesture(perform: {
                        selectedIndex = index
                    })
                    .ifdo(index == selectedIndex) { view in
                        view.background {
                            Capsule()
                                .fill("#FCCC46".color!.opacity(0.1))
                                .frame(width: itemSize.width, height: itemSize.height)
                                .matchedGeometryEffect(id: "title", in: namespace)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
