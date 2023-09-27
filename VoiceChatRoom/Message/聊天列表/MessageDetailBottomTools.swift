//
//  MessageDetailBottomTools.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/22.
//

import SwiftUI
import SwiftUITools

struct MessageDetailBottomTools: View {
    enum InputType {
        case text
        case voice
    }
    @State var inputType: InputType
    @Binding var text: String
    @Binding var showMoreFunctionView: Bool
    @Binding var isTalking: Bool
    @Binding var showEmotionList: Bool
    @Binding var showGiftList: Bool
    @Binding var shouldUpdateMessages: Bool
    var targetId: String
//    @Binding var messages: [MessageModel]
    @FocusState private var isTextFieldShow: Bool
    var audioRecorder = AudioRecorder()
    
    var body: some View {
        HStack(spacing: 12) {
            if inputType == .text {
                Image("xiaoxi_yuyin")
                    .onTapGesture {
                        withAnimation {
                            inputType = .voice
                        }
                    }
                TextField("", text: $text, prompt: Text("说说什么…").foregroundColor(.white.opacity(0.3)))
                    .TextFieldSett(textC: .white, cursorC: .white, fontN: .PingFangSCRegular, fontS: 14)
                    .focused($isTextFieldShow)
                    .padding([.top, .bottom], 9)
                    .padding(.leading, 12)
                    .frame(height: 38)
                    .background("#474352".color)
                    .cornerRadius(19)
                    .transition(.opacity)
                    .onSubmit {
                        Task {
                            let successed = try await RongYunManager.shared.sendTextMessage(message: text, targetId: targetId)
                            if successed {
                                shouldUpdateMessages = true
                            }
                        }
                    }
                    .onChange(of: isTextFieldShow) { newValue in
                        if newValue == true {
                            showEmotionList = false
                            showMoreFunctionView = false
                            showGiftList = false
                        }
                    }
            } else {
                Image("xiaoxi_jianpan")
                    .onTapGesture {
                        withAnimation {
                            inputType = .text
                        }
                    }
                Capsule().fill("#474352".color!)
                    .frame(height: 38)
                    .overlay {
                        Text("按住说话")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                    }
                    .transition(.opacity)
                    .touchEnterExit {
                        if audioRecorder.recording {
                            return
                        } else {
                            audioRecorder.startRecording()
                        }
                    } onExit: {
//                        let url = audioRecorder.stopRecording()
//                        let nurl = audioRecorder.recordings.filter{$0.fileURL.lastPathComponent == url.lastPathComponent}.first?.fileURL
//                        messages.append(MessageModel(id: UUID().uuidString, type: .audio, audioModel: AudioMessageModel(owner: .mine, url: nurl!, yidu: false)))
                    }
                
            }
            Image("xiaoxi_shequ")
                .onTapGesture {
                    showMoreFunctionView = false
                    showEmotionList.toggle()
                }
            Image("xiaoxi_liwu")
            Image("xiaoxi_gengduo")
                .onTapGesture {
                    showEmotionList = false
                    showMoreFunctionView.toggle()
                }
        }
        .padding([.leading, .trailing], 12)
        .padding([.top, .bottom], 12)
        .background("#191527".color)
    }
}

struct EmotionListView: View {
    @State var model: EmotionListModel?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            let grids = [GridItem](repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: grids, spacing: 15) {
                let emotions = model?.data.valueIn(index: 0)?.expressionList
                ForEach(emotions ?? [], id:\.eid) { emotion in
                    let url = URL(string: emotion.icon)
                    CachedAsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 27, height: 27)
                }
            }
//            .frame(maxWidth: .infinity)
        }
        .padding([.top, .bottom],18)
        .frame(height: 216)
        .background("#050017".color)
        .onAppear {
            if model == nil {
                Task {
                    model = try await API.IM.emotionList()
                }
            }
        }
    }
}

struct MessageDetailBottomTools_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailBottomTools(inputType: .voice, text: .constant("abc"), showMoreFunctionView: .constant(false), isTalking: .constant(false), showEmotionList: .constant(false), showGiftList: .constant(false), shouldUpdateMessages: .constant(false), targetId: "14950")
    }
}
