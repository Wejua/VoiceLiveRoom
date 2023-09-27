//
//  AudioItem.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/8.
//

import SwiftUI
import SwiftUITools

struct AudioItem: View {
    var url: URL
    var yidu: Bool?
    @State private var imageName = "audioplay3"
    @State private var timer: Timer?
    @StateObject private var audioPlayer: AudioPlayer = AudioPlayer()
    
    init(url: URL, yidu: Bool? = nil) {
        self.url = url
        self.yidu = yidu
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Spacer()
            HStack(alignment: .bottom, spacing: 0) {
                if yidu != nil {
                    Text(yidu == true ? "已读" : "未读")
                        .textSett(color: yidu == true ? .white.opacity(0.3) : "#F8C945".color!, FName: .PingFangSCRegular, Fsize: 11, lineLi: 1)
                        .padding(.bottom, 2)
                        .padding(.trailing, 4)
                }
                HStack(spacing: 4) {
                    let player = AudioPlayer()
                    let _ = player.setup(audioUrl: url)
                    Text("\(player.audioPlayer.duration, specifier: "%.0f")’’")
                        .textSett(color: "#181818".color!, FName: .PingFangSCRegular, Fsize: 16, lineLi: nil)
                    Image(imageName)
                }
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 10)
                .background("#F8C945".color!)
                .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                .cornerRadius(3, corners: .topRight)
                .onTapGesture {
                    if audioPlayer.isPlaying {
                        audioPlayer.stopPlayback()
                    } else {
                        audioPlayer.startPlayback(audio: url)
                    }
                }
                .onReceive(audioPlayer.objectWillChange) { player in
                    if player.isPlaying == false {
                        stop()
                    } else {
                        play()
                    }
                }
            }
            AsyncImage(url: URL(string: ""), content: {$0}, placeholder: {Color.gray})
                .frame(width: 39, height: 39)
                .clipShape(Circle())
                .padding(.leading, 10)
        }
        .padding(.trailing, 15)
        .padding(.leading, 24)
        .padding(.top, 16)
    }
    
    private func play() {
        timer?.invalidate()
        var index = 1
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            imageName = "audioplay\(index)"
            index += 1
            if (index > 3) {
                index = 1
            }
        }
    }

    private func stop() {
        imageName = "audioplay3"
        timer?.invalidate()
    }
}

struct AudioItem_Previews: PreviewProvider {
    static var previews: some View {
        AudioItem(url: URL(string: "")!)
    }
}
