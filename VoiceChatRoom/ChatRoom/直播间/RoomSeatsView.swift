//
//  RoomSeatsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/24.
//

import SwiftUI
import SwiftUITools

extension RoomView {
    
    @ViewBuilder func seatsView() -> some View {
        switch seatNum {
        case 15,  10:
            let gridItems = [GridItem](repeating: GridItem(.flexible()), count: 5)
            otherCountSeatsView(items: gridItems, seatNum: seatNum!)
        case 8:
            let gridItems = [GridItem](repeating: GridItem(.flexible()), count: 4)
            otherCountSeatsView(items: gridItems, seatNum: seatNum!)
        case 3:
            threeSeatsView()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder func otherCountSeatsView(items: [GridItem], seatNum: Int) -> some View {
        HStack(spacing: 0) {
            LazyVGrid(columns: items, alignment: .center, spacing: 0) {
                ForEach(0..<seatNum, id: \.self) { index in
                    let seatId = changeIndexToSeatNo(index: index)
                    let seatM = seatsModel?.data?.filter{$0.seatId == seatId}.first
                    VStack(spacing:  0) {
                        ZStack {
                            Color.clear
                                .frame(width: 62, height: 62)
                            Image("rentouzhanwen")
                        }
                        .overlay {
                            let url = URL(string: seatM?.avatar ?? "")
                            CachedAsyncImage(url: url, content: {image in
                                image.resizable().scaledToFill()
                            }, placeholder: {})
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        .overlay {
                            let url = URL(string: seatM?.headWear ?? "")
                            CachedAsyncImage(url: url, content: {image in
                                image.resizable().scaledToFill()
                            }, placeholder: {})
                                .frame(width: 62, height: 62)
                                .clipShape(Circle())
                        }
                        HStack(spacing: 2) {
                            numberView(number: index+1)
                            let name = seatM?.username
                            Text(name ?? "号麦")
                                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 10, lineLi: 1, maxW: nil)
                        }
                    }
                    .onTapGesture {
                        //座位上没人，点击上麦
                        if seatM?.uid == 0 {
                            Task {
                                let _ = try await API.Room.onOrOffSeat(roomId: roomId, seatNo: seatId, targetUid: selfId, type: 1)
                            }
                        } else {
                            currentUid = seatM?.uid
                            showMemberInfo = checkActionSheetButtonTitle()
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 7)
        }
    }
    
    @ViewBuilder func numberView(number: Int) -> some View {
        Text("\(number)")
            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 10, lineLi: 1, maxW: nil)
            .frame(width: 14, height: 14)
            .background("#000000".color(alpha: 0.35))
            .clipShape(Circle())
    }
    
    @ViewBuilder private func microphone(seatModel: RoomSeatInfoModel.SeatModel?) -> some View {
        VStack(spacing: 3) {
            let url  = URL(string: seatModel?.avatar ?? "")
            AsyncImage(url: url) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image("rentouzhanwen")
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            HStack(spacing: 2) {
                Text(seatModel?.username ?? "--")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 10, lineLi: 1, maxW: nil)
            }
            .padding(.top, 3)

        }
    }
    
    @ViewBuilder private func threeSeatsView() -> some View {
        HStack {
            Spacer()
            ZStack {
                VStack(spacing: 10) {
                    let seatModel = seatsModel?.data?.filter{$0.seatId == 8}.first
                    let url = URL(string: seatModel?.avatar ?? "")
                    CachedAsyncImage(url: url, content: {image in
                        image.resizable().scaledToFill()
                    }, placeholder: {
                        Image("rentouzhanwen").resizable().scaledToFill()
                    })
                    //                                .frame(width: 93, height: 93)
                    .frame(width: 75, height: 75)
                    .onTapGesture {
                        showMemberInfo.toggle()
                    }
                    HStack(alignment: .center, spacing: 2) {
                        Text("\(seatModel?.username ?? "--")")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1, maxW: nil)
                    }
                    Spacer()
                }
                .frame(width: 93, height: 136)
                .padding(.bottom, 136)
                HStack(spacing: 38) {
                    let model1 = seatsModel?.data?.filter{$0.seatId == 0}.first
                    microphone(seatModel: model1)
                        .frame(width: 75, height: 75)
                    let model2 = seatsModel?.data?.filter{$0.seatId == 1}.first
                    microphone(seatModel: model2)
                        .frame(width: 75, height: 75)
                        .padding(.top, 75)
                    let model3 = seatsModel?.data?.filter{$0.seatId == 7}.first
                    microphone(seatModel: model3)
                        .frame(width: 75, height: 75)
                }
            }
            Spacer()
        }
    }
}

