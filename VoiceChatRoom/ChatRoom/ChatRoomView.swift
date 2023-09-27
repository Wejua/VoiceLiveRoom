//
//  ChatRoomView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/14.
//

import SwiftUI
import SwiftUITools
import ModalPresenter

enum Gender: Int, Codable {
    case unknow = 0
    case male = 1
    case female = 2
}

class RoomModel: ObservableObject, Codable {
    
    var roomName: String
    var roomTypeName: String
    var roomType: Int
    var roomHeat: String
    var roomID: Int
    var memberCount: Int
    var needPwd: Bool
    var roomIconUrl: String
    var haveRedBag: Bool
    var homeownerGender: Gender
    
    enum CodingKeys:String,  CodingKey {
        case roomName = "title"
        case roomTypeName = "label"
        case roomType = "roomtype"
        case roomHeat = "theHeat"
        case roomID = "roomid"
        case memberCount = "num"
        case needPwd = "needPwd"
        case roomIconUrl = "icon"
        case haveRedBag
        case homeownerGender
    }
}

struct NoDataView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Image("xiaoxi_nodata")
            Text("暂无数据")
                .textSett(color: "#FCCC46".color!.opacity(0.5), FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                .padding(.top, 12)
        }
    }
}

//struct BackgroundCleanerView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        DispatchQueue.main.async {
//            view.superview?.superview?.backgroundColor = .clear
//        }
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}

struct ChatRoomView: View {
    private let coordinateSpaceName = UUID()
    private let itemSpacing = 12.0
    private let itemHeight = 108.0
    @State private var rooms: [RoomModel] = []
    @State private var nextPage = 2
    @State private var noMoreData: Bool = false
    @State private var didLoadedData: Bool = false
    @State private var showRoomView: Bool = false
    @State private var minimize: Bool = false
    private let configuration = ModalPresenterConfiguration(animated: true, context: .automatic, backgroundColor: .clear, modalPresentationStyle: .overFullScreen, modalTransitionStyle: .coverVertical, configurePresentedViewController: {_ in})
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: itemSpacing*factor) {
                    ForEach(0..<rooms.count, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink {
                                RoomView(roomId: rooms[index].roomID, showRoomView: $showRoomView, minimize: $minimize)
                            } label: {
                                cell(factor: factor, middleY: geo.size.height/2.0, model: rooms[index])
                                    .padding(.leading, 16*factor)
                                    .onAppear {
                                        if index == rooms.count - 3 {
                                            loadData(loadMore: true, refresh: false)
                                        }
                                    }
//                                    .onTapGesture {
//                                        showRoomView.toggle()
//                                    }
//                                    .presentModal(isPresented: $showRoomView, configuration: configuration) {
//                                            RoomView(roomId: rooms[index].roomID, showRoomView: $showRoomView, minimize: $minimize)
//                                    }
                            }
                        }
                    }
                }
            }
            .background {
                if (rooms.count == 0) {
                    NoDataView()
                }
            }
            .refreshable {
                loadData(loadMore: false, refresh: true)
            }
            .onAppear {
                if !didLoadedData {
                    loadData(loadMore: false, refresh: true)
                }
            }
            .coordinateSpace(name: coordinateSpaceName)
            .overlay(alignment: .bottomTrailing) {
                if minimize {
                    minimizeContent()
                        .padding(.trailing, 23)
                        .padding(.bottom, 30)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func minimizeContent() -> some View {
            Image("roomMinimize")
                .overlay(content: {
                    CachedAsyncImage(url: nil) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        placeHolderColor
                    }
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
                    .onTapGesture {
//                        minimize.toggle()
//                        isShowing = false
                        showRoomView.toggle()
                    }

                })
                .overlay(alignment: .topTrailing) {
                    Image("roomMinimize_guanbi")
                        .offset(x: 3, y: -3)
                        .onTapGesture {
                            showRoomView = false
                            minimize = false
                        }
                }
    }
    
    @MainActor
    private func loadData(loadMore: Bool, refresh: Bool) {
        if loadMore && noMoreData {return}
        Task {
            let page = loadMore ? nextPage : 1
            let data = try await API.Room.roomsList(page: page, pageSize: 20, type: 2)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {return}
            if json["content"] as? String == "需要重新登陆" {
                Store.shared.loginOut()
            }
            guard let rooms = json["data"] else {return}
            let roomsData = try JSONSerialization.data(withJSONObject: rooms)
            let roomModels = try JSONDecoder().decode([RoomModel].self, from: roomsData)
            if loadMore {
                if roomModels.count == 0 {
                    noMoreData = true
                } else {
                    nextPage = page + 1
                    self.rooms.append(contentsOf: roomModels)
                }
            } else {
                if refresh {
                    nextPage = 2
                }
                self.rooms = roomModels
                didLoadedData = true
            }
        }
    }
    
    @ViewBuilder private func cell(factor: CGFloat, middleY: CGFloat, model: RoomModel) -> some View {
        
        GeometryReader { geo in
            cellBackground(factor: factor, middleY: middleY, geo: geo)
                .overlay(alignment: .leading) {
                    HStack(spacing: 0) {
                        CachedAsyncImage(url: URL(string: model.roomIconUrl)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            "#1F265F".color(alpha: 0.6)!
                        }
                        .frame(width: 84*factor, height: 84*factor)
                        .cornerRadius(12*factor, corners: .allCorners)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(model.roomName)
                                .textSett(color: .white, FName: .PingFangSCSemibold, Fsize: 16*factor, lineLi: 1, maxW: 150)
                            Text("ID: \(String(model.roomID))")
                                .foregroundColor("FFFFFF".color(alpha: 0.7))
                                .font(name: .PingFangSCRegular, size: 12*factor)
                                .padding(.top, 4*factor)
                            Image("jiaoyouicon")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(height: 15*factor)
                                .padding(.top, 2)
                            Spacer()
                            HStack(spacing: 0) {
                                Image("roomcellperson")
                                Text("\(String(model.memberCount))")
                                    .foregroundColor("#FCCC46".color)
                                    .font(name: .PingFangSCRegular, size: 12*factor)
                                    .padding(.leading, 6*factor)
                                Text("人在线")
                                    .foregroundColor("#55586C".color)
                                    .font(name: .PingFangSCRegular, size: 12*factor)
                                    .padding(.leading, 6*factor)
                            }
                            .padding(.bottom, 12*factor)
                        }
                        .padding([.leading, .top], 12*factor)
                    }
                    .padding(.leading, 12*factor)
                }
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 0) {
                        Image("chatroomxinhao").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 12*factor)
                        
                        Text("\(model.roomHeat)")
                            .foregroundColor("#55586C".color)
                            .font(name: .PingFangSCRegular, size: 12*factor)
                            .padding(.leading, 2*factor)
                    }
                    .padding([.bottom, .trailing], 12*factor)
                }
            
        }
        .frame(height: itemHeight*factor)
    }
    
    @ViewBuilder private func cellBackground(factor: CGFloat, middleY: CGFloat, geo: GeometryProxy) -> some View {
        let cornerRadius = 12.0*factor
        let minWidth = 273*factor
        let maxWidth = 318*factor
        let itemWidthOffset = abs(geo.frame(in: .named(coordinateSpaceName)).origin.y-middleY+105)/7.0
        let itemWidth = max(maxWidth-itemWidthOffset, minWidth)
        RoundedRectangle(cornerRadius: cornerRadius)
            .frame(width: itemWidth, height: itemHeight*factor)
            .foregroundStyle(LinearGradient(stops: [.init(color: "#010209".color(alpha: 0.6)!, location: 0) , .init(color: "#1F265F".color(alpha: 0.6)!, location: 1)], startPoint: .leading, endPoint: .trailing))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(LinearGradient(colors: ["#FFFFFF".color(alpha: 0.0)!, "#FFFFFF".color(alpha: 0.6)!], startPoint: .leading, endPoint: .trailing))
                    .padding(0.5)
            }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}
