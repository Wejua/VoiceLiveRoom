//
//  GiftListView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/7.
//

import SwiftUI
import SwiftUITools

struct GiftListView: View {
    private var countAndTitleS: [(count: Int, title: String)] = [(1, "暂无特效"), (10, "暂无特效"), (66, "一切顺利"), (99, "长长久久"), (188, "要抱抱"), (520, "我爱你"), (1314, "一生一世")]
    @State private var model: RoomGiftListModel?
    @State private var showCountsView: Bool = false
    @State private var currentCount: Int = 1314
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topView()
            
            Rectangle().fill(.black.opacity(0.7))
                .frame(height: 1)
            
            RoomGiftViewGiftType()
                .frame(height: 40)
                .padding(.leading, 10)
            
            giftsView()
            
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image("zuanshi")
                    Text("288868")
                        .textSett(color: .white, FName: .PingFangSCSemibold, Fsize: 14, lineLi: nil)
                        .padding(.leading, 4)
                    HStack(spacing: 2.5) {
                        Text("充值")
                            .textSett(color: "#FFC942".color!, FName: .PingFangSCRegular, Fsize: 10, lineLi: nil)
                        Image("giftlistArrow")
                    }
                    .frame(width: 40, height: 20)
                    .background("#FFC942".color!.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading, 7)
                }
                .padding(.leading, 15)
                
                Spacer()
                    
                HStack(spacing: 0) {
                    Text(String(format: "%d", currentCount))
                        .textSett(color: .white, FName: .PingFangSCSemibold, Fsize: 14, lineLi: nil)
                        .padding(.leading, 10.5)
                    Image("giftnext_white")
                        .ifdo(showCountsView, transform: { image in
                                image.rotationEffect(Angle(degrees: 180))
                        })
                        .padding(.leading, 2.5)
                    Spacer()
                }
                .frame(width: 120, height: 30)
                .background("ffffff".color!.opacity(0.2))
                .cornerRadius(15)
                .onTapGesture(perform: {
                    showCountsView.toggle()
                })
                .overlay(alignment: .trailing) {
                    Text("赠送")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 13, lineLi: nil)
                        .frame(width: 60, height: 30)
                        .background {
                            LinearGradient(colors: ["#FF6550".color!, "#FF6DAC".color!], startPoint: .leading, endPoint: .trailing)
                        }
                        .cornerRadius(15)
                }
            }
            .frame(height: 49)
        }
        .background(.black)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .overlay(alignment: .bottomTrailing) {
            if showCountsView {
                countsView()
            }
        }
        .onAppear {
            Task {
                self.model = try await API.Room.roomGiftList(isFamily: 0, targetUid: nil, type: 0)
            }
        }
    }
    
    @ViewBuilder private func countsView() -> some View {
        LazyVStack(spacing: 6) {
            ForEach(countAndTitleS, id: \.count) { item in
                HStack(spacing: 0) {
                    Text(String(format: "%d", item.count))
                        .textSett(color: "#FF6550".color!, FName: .PingFangSCMedium, Fsize: 11, lineLi: nil)
                        .padding(.leading, 7)
                    Spacer()
                    let color = item.title == "暂无特效" ? Color.white.opacity(0.5) : .white
                    Text(item.title)
                        .textSett(color: color, FName: .PingFangSCRegular, Fsize: 11, lineLi: nil)
                        .padding(.trailing, 7)
                }
                .frame(width: 94, height: 21)
                .overlay {
                    RoundedRectangle(cornerRadius: 10.5, style: .circular)
                        .stroke(.white.opacity(0.1), style: StrokeStyle(lineWidth: 0.5))
                }
                .onTapGesture {
                    currentCount = item.count
                    showCountsView.toggle()
                }
            }
            
            Text("其他数量")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 11, lineLi: nil)
        }
        .frame(width: 110, height: 220)
        .background("#252540".color!)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .stroke("#464657".color!, style: StrokeStyle(lineWidth: 1))
        }
        .padding(.bottom , 54)
        .offset(x: -20)
    }
    
    @ViewBuilder private func giftsView() -> some View {
        let spacing = (UIScreen.main.bounds.size.width - 88*4)/5.0
        let items = [GridItem](repeatElement(GridItem(.fixed(88), spacing: spacing), count: 4))
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: items, spacing: spacing) {
                let gifts = model?.data.list ?? []
                ForEach(gifts, id:\.id) { gift in
                    VStack(spacing: 2) {
                        let url = URL(string: gift.icon ?? "")
                        CachedAsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.clear
                        }
                        .frame(width: 60, height: 60)
                        
                        Text(gift.name ?? "--")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                        
                        HStack(spacing: 3) {
                            Image("zuanshixiao")
                            Text("\(gift.counts ?? 0)")
                                .textSett(color: "#6D7278".color!, FName: .PingFangSCSemibold, Fsize: 10, lineLi: nil)
                        }
                    }
                }
            }
        }
        .frame(height: 250)
    }
    
    @ViewBuilder private func topView() -> some View {
        let tintColor = "#FF6550".color!
        HStack(spacing: 13) {
            GiftListViewSegmentView()
            
            Rectangle().fill("000000".color!.opacity(0.5))
                .frame(width: 0.5, height: 17)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(0..<10, id: \.self) { _ in
                        CachedAsyncImage(url: nil) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 27, height: 27)
                        .clipShape(Circle())
                        .padding(.bottom, 6)
                        .overlay(alignment: .bottom) {
                            Text("主持")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 7, lineLi: nil)
                                .frame(width: 20, height: 12)
                                .background("#8D93B1".color!)
                                .cornerRadius(6)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("全麦")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 10, lineLi: nil)
                .frame(width: 40, height: 22)
                .background(tintColor)
                .cornerRadius(11)
                .padding(.trailing, 10)
        }
        .frame(height: 49)
    }
}

struct GiftListView_Previews: PreviewProvider {
    static var previews: some View {
        GiftListView()
    }
}
