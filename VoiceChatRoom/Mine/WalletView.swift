//
//  WalletView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/23.
//

import SwiftUI

struct WalletView: View {
    enum Amounts: Int, CaseIterable {
        case yi = 50
        case er = 100
        case san = 200
        case si = 300
        case wu = 500
        case liu = 600
        case qi = 700
        case ba = 800
    }
    
    @State var currentAmount: Amounts = .yi
    
    var body: some View {
        VStack(spacing: 0) {
            balanceView()
                .padding(.top, 26)
            
            Text("选择充值金额")
                .textSett(color: .white, FName: .PingFangSCSemibold, Fsize: 16, lineLi: 1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                .padding(.leading, 15)
            
            amountView()
            
            Spacer()
            
            Text("确认充值")
                .textSett(color: "#311D08".color!, FName: .PingFangSCMedium, Fsize: 16, lineLi: 1)
                .frame(width: 280, height: 52)
                .background("#FCCC46".color)
                .cornerRadius(52/2.0)
        }
        .navigationTitle("钱包")
        .customBackView {
            Image("backArrow")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    BillDetailView()
                } label: {
                    Text("收支明细")
                        .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1).frame(height: 30)
                }
            }
        }
    }
    
    @ViewBuilder private func amountView() -> some View {
        let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Amounts.allCases, id:\.rawValue) { amount in
                HStack(spacing: 0) {
                    Image("caifudengji")
                    Text("\(amount.rawValue)")
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        .padding(.leading, 6)
                    Spacer()
                    Text("¥\(amount.rawValue/10).00")
                        .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                }
                .padding(10)
                .frame(height: 36)
                .cornerRadius(18)
                .overlay {
                    let color = amount == currentAmount ? "#FCCC46".color! : "#251E0C".color!
                    Capsule().strokeBorder(color, lineWidth: 1)
                }
                .onTapGesture {
                    currentAmount = amount
                }
            }
        }
        .padding([.leading, .trailing], 15)
        .padding(.top, 20)
    }
    
    private func balanceView() -> some View {
        HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 4) {
                        Image("zhuanshi")
                        Text("钻石余额")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                    Text("1482")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 26, lineLi: 1)
                        .padding(.top, 6)
//                    HStack(spacing: 0) {
//                        Text("钻石提现 >")
//                            .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
//
//                    }
//                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 4) {
                        Image("caifudengji")
                        Text("金币余额")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                    }
                    Text("1482")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 26, lineLi: 1)
                        .padding(.top, 6)
//                    HStack(spacing: 0) {
//                        Text("兑换金币 >")
//                            .textSett(color: .white.opacity(0.6), FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
//
//                    }
//                    .padding(.top, 8)
                }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 15)
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
