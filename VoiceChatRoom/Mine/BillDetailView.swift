//
//  BillDetailView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI
import SwiftUITools

struct BillDetailView: View {
    @State private var segmentCurrentIndex: Int = 0
    @State private var showFilterView: Bool = false
    @State private var currentFilterIndex: Int = 0
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                CapsuleSegmentView(titles: ["U币", "钻石"], titleFontSize: 14, itemSize: CGSize(width: 50, height: 30), selectedIndex: $segmentCurrentIndex)
                
                scrollView()
            }
            .background(primaryColor)
            .customBackView {
                Image("backArrow")
            }
            .navigationTitle("账单明细")
            .navigationBarTitleDisplayMode(.inline)
//            .topSafeAreaColor(color: .white)
//            .bottomSafeAreaColor(color: "#F6F7F9".color!)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("mingxi_filter")
                        .onTapGesture {
                            showFilterView.toggle()
                        }
                }
            }
            
            Sheet(edge: .bottom, isShowing: $showFilterView) {
                filterView()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @ViewBuilder private func filterView() -> some View {
        let grids = [GridItem](repeating: GridItem(.flexible(minimum: 74), spacing: 0), count: 4)
        let titles = ["全部", "全部收入", "全部支出", "礼物", "充值", "提现"]
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: grids, spacing: 15) {
                ForEach(titles.indices, id: \.self) { index in
                    let color = currentFilterIndex == index ? tintColor : captionColor
                    Text(titles[index])
                        .textSett(color: color, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                        .frame(width: 74, height: 30)
                        .ifdo(currentFilterIndex == index) { view in
                            view.background {
                                Capsule().fill(tintBackground)
                            }
                        }
                        .ifdo(currentFilterIndex != index) { view in
                            view.overlay {
                                RoundedRectangle(cornerRadius: 15, style: .circular)
                                    .stroke(captionColor, style: StrokeStyle(lineWidth: 1))
                            }
                        }
                        .onTapGesture {
                            currentFilterIndex = index
                        }
                }
            }
            .padding(.top, 30)
            Text("确定")
                .textSett(color: onTintColor, FName: .PingFangSCMedium, Fsize: 15, lineLi: nil)
                .frame(width: 160, height: 50)
                .background {
                    tintColor
//                    LinearGradient(colors: ["#FF6550".color!, "#FF6DAC".color!], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(25)
                .padding(.top, 49)
                .padding(.bottom, 59)
        }
        .background {
            primaryColor
        }
        .frame(height: 263)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder private func scrollView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(0..<2, id:\.self) { _ in
                    Section {
                        NavigationLink {
                            BillItemDetialView()
                        } label: {
                            sectionContentView()
                        }
                    } header: {
                        sectionHeaderView(title: "2019年06月06日")
                    }
                }
            }
        }
        .background(primaryColor)
    }
    
    @ViewBuilder private func sectionHeaderView(title: String) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill("#FF3C00".color!)
                .frame(width: 3, height: 10)
            Text(title)
                .textSett(color: titleColor, FName: .PingFangSCMedium, Fsize: 13, lineLi: 1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding([.top, .bottom], 12)
        .padding(.leading, 15)
    }
    
    @ViewBuilder private func sectionContentView() -> some View {
        let titles = ["礼物消费", "礼物收入", "语音消费", "语音收入"]
        let detail = -20.00
        VStack(spacing: 0) {
            ForEach(titles, id: \.self) { title in
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text(title)
                            .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                        Text("11:43")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: 0)
                    }
                    Spacer()
                    let color = detail > 0 ? tintColor : subTitleColor
                    Text(String(format:"%.2f", detail))
                        .textSett(color: color, FName: .PingFangSCSemibold, Fsize: 17, lineLi: nil)
                    Image("mingxi_arrow")
                        .padding(.leading, 10.5)
                }
                .padding(.leading, 26)
                .padding(.trailing, 10)
                .padding(.top, 11)
                .padding(.bottom, 5.5)
                .background(secondaryColor)
            }
        }
    }
}

struct BillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BillDetailView()
    }
}
