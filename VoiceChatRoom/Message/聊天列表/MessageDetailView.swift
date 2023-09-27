//
//  MessageDetailView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/20.
//

import SwiftUI
import AVFoundation
import SwiftUITools
import RongIMLib
import RongIMLibCore

struct MessageModel {
    enum MessageType {
        case time
        case text
        case audio
    }
    enum Owner {
        case mine, other
    }
    
    var id: String
    var type: MessageType
    var textModel: TextMessageModel?
    var timeModel: TimeMessageModel?
    var audioModel: AudioMessageModel?
}

struct TextMessageModel {
    var owner: MessageModel.Owner
    var text: String = ""
    var yidu: Bool?
}

struct AudioMessageModel {
    var owner: MessageModel.Owner
    var url: URL
    var yidu: Bool?
}

struct TimeMessageModel {
    var time: String
}

struct MessageDetailView: View {
    
    var conversationId: String
    @Binding var basicInfo: BasicInfoModel?
    @State private var text: String = ""
    @State var showMoreFunctionView: Bool = false
    @State var showCamera: Bool = false
    @State var showPhotoLibrary: Bool = false
    @State var selectedCameraImage: UIImage? = nil
    @State var selectedPhotoLibraryImage: UIImage? = nil
    var toolImages: [String] = ["xiaoxi_xiangce", "xiaoxi_paishe"]
    @State var seconds: Int = 0
    @State var imageName: String = ""
    @State var imageTimer: Timer?
    @State var secondsTimer: Timer?
    @State var isTalking: Bool = false
    @State var showEmotionList: Bool = false
    @State var showGiftList: Bool = false
    @State var messages: [RCMessage] = []
    @State var shouldUpdateMessages: Bool = false
//    @State var messages: [MessageModel] = [
//        MessageModel(id: "1",type: .time, timeModel: TimeMessageModel(time: "09/05 18:00")),
//        MessageModel(id: "2",type: .text, textModel: TextMessageModel(owner: .other, text: "现在有空吗？")),
//        MessageModel(id: "3",type: .text, textModel: TextMessageModel(owner: .other, text: "你自己觉得有，别人感觉不到现在有空吗你有")),
//        MessageModel(id: "4",type: .text, textModel: TextMessageModel(owner: .mine, text: "嘿嘿", yidu: true)),
//        ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(messages, id:\.messageId) { message in
//                    switch message.type {
//                    case .text:
                    messageItem(message: message)
//                    messageItem(text: text ?? "", direction: message.messageDirection, yidu: message.receivedStatus == .ReceivedStatus_READ)
//                    case .time:
//                        timeItem(time: message.timeModel!.time)
//                    case .audio:
//                        AudioItem(url: message.audioModel!.url, yidu: message.audioModel!.yidu)
//                    }
                }
            }
            .onAppear {
                loadMessages()
            }
        }
        .overlay(alignment: .bottom) {
            if isTalking {
                VStack(spacing: 12) {
                    Circle().fill("#474352".color!)
                        .frame(width: 80, height: 80)
                        .overlay {
                            Image(imageName)
                        }
                    Text("\(seconds)″")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                }
                .padding(.bottom, 55)
                .onAppear {
                    setTalkingTimer()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                MessageDetailBottomTools(inputType: .voice, text: $text, showMoreFunctionView: $showMoreFunctionView, isTalking: $isTalking, showEmotionList: $showEmotionList, showGiftList: $showGiftList, shouldUpdateMessages: $shouldUpdateMessages, targetId: conversationId)
                    .onChange(of: shouldUpdateMessages) { newValue in
                        if newValue == true {
                            loadMessages()
                        }
                    }
                if showMoreFunctionView {
                    moerFunctionView()
                        .transition(.move(edge: .bottom))
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                if showEmotionList {
                    EmotionListView()
                        .transition(.move(edge: .bottom))
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showMoreFunctionView)
            .animation(.easeInOut(duration: 0.3), value: showEmotionList)
        }
        .modifier(MessageDetailViewModifiers(showMoreFunctionView: $showMoreFunctionView, showEmotionList: $showEmotionList, showGiftList: $showGiftList, basicInfoModel: $basicInfo))
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedCameraImage)
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedPhotoLibraryImage)
        }
        
    }
    
    func loadMessages() {
        Task { @MainActor in
            async let messages = RongYunManager.shared.getHistoryMessages(targetId: conversationId, oldestMessageId: -1) ?? []
            self.messages = try await messages
            shouldUpdateMessages = false
        }
    }
    
    private func setTalkingTimer() {
        self.imageTimer?.invalidate()
        self.secondsTimer?.invalidate()
        var index = 1
        self.imageTimer = Timer(timeInterval: 0.2, repeats: true) { timer in
            imageName = "yuyin\(index)"
            index += 1
            if index > 6 {
                index = 1
            }
        }
        RunLoop.current.add(self.imageTimer!, forMode: .common)

        seconds = 0
        self.secondsTimer = Timer(timeInterval: 1, repeats: true) { timer in
            seconds += 1
        }
        RunLoop.current.add(self.secondsTimer!, forMode: .common)
    }
    
    @ViewBuilder private func moerFunctionView() -> some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                let itemW = 65.0
                let width = geo.size.width
                let maxCount: Int = 4
                let margins = Double(maxCount + 1)
                let spacing = (width-itemW*Double(maxCount))/margins
                let columns = [GridItem](repeating: GridItem(.fixed(itemW), spacing: spacing), count: maxCount)
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(toolImages, id: \.self) { name in
                        Image(name).resizable().scaledToFit()
                            .ifdo(name == "xiaoxi_xiangce", transform: { view in
                                view.onTapGesture {
                                    showPhotoLibrary.toggle()
                                }
                            })
                            .ifdo(name == "xiaoxi_paishe", transform: { view in
                                view.onTapGesture {
                                    showCamera.toggle()
                                }
                            })
//                            .transition(.move(edge: .bottom))
                    }
                }
                .padding(.top, spacing)
            }
        }
        .background("#050017".color)
        .frame(height: 216)
//        .transition(.move(edge: .bottom))
    }

    private func timeItem(time: String) -> some View {
        Text(time)
            .textSett(color: .white.opacity(0.3), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
            .padding(.top, 16)
    }
    
    @ViewBuilder private func messageItem(message: RCMessage) -> some View {
        let text = (message.content as? RCTextMessage)?.content ?? ""
        let avatar = basicInfo?.portraitUrl ?? ""
        if message.messageDirection == .MessageDirection_SEND {
            HStack(alignment: .top, spacing: 0) {
                AsyncImage(url: URL(string: avatar), content: {$0.resizable().scaledToFill()}, placeholder: {Color.gray})
                    .frame(width: 39, height: 39)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                Text(text)
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: nil)
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 10)
                    .background("#373345".color)
                    .cornerRadius(10, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(3, corners: .topLeft)
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 50)
            .padding(.top, 16)
        } else {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    let isRead = message.receivedStatus == .ReceivedStatus_READ
                    Text(isRead ? "已读" : "未读")
                        .textSett(color: isRead ? .white.opacity(0.3) : "#F8C945".color!, FName: .PingFangSCRegular, Fsize: 11, lineLi: 1)
                        .padding(.bottom, 2)
                        .padding(.trailing, 4)
                    
                    Text(text)
                        .textSett(color: "#181818".color!, FName: .PingFangSCRegular, Fsize: 16, lineLi: nil)
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 10)
                        .background("#F8C945".color!)
                        .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                        .cornerRadius(3, corners: .topRight)
                }
                AsyncImage(url: URL(string: avatar), content: {$0}, placeholder: {Color.gray})
                    .frame(width: 39, height: 39)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            }
            .padding(.trailing, 15)
            .padding(.leading, 24)
            .padding(.top, 16)
        }
    }
}

struct MessageDetailViewModifiers: ViewModifier {
    @Binding var showMoreFunctionView: Bool
    @Binding var showEmotionList: Bool
    @Binding var showGiftList: Bool
    @Binding var basicInfoModel: BasicInfoModel?
    private var safeBottomColor: Color {
        var safeBottomColor: Color = Color.clear
        if showMoreFunctionView || showEmotionList || showGiftList {
            safeBottomColor = "#050017".color!
        } else {
            safeBottomColor = "#191527".color!
        }
        return safeBottomColor
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .background("#050017".color)
            .customBackView {
                Image("backArrow")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("roomMorebutton")
                }
                ToolbarItem(placement: .principal) {
                    Text(basicInfoModel?.userName ?? "")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 17, lineLi: 1)
                }
            }
            .toolbarBackground("#191527".color!, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .topSafeAreaColor(color: "#191527".color)
            .bottomSafeAreaColor(color: safeBottomColor)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(conversationId: "", basicInfo: .constant(nil))
    }
}
