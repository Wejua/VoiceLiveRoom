//
//  BillItemDetialView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/5/10.
//

import SwiftUI

struct BillItemDetialView: View {
    var body: some View {
        VStack(spacing: 0) {
            let items:[(title: String, detail: String)] = [("收入时间","2019-09-14 11:43"), ("收入项目", "第五人格-订单取消"), ("消费者", "酒神"), ("收入金额", "200钻石")]
            VStack(alignment: .leading, spacing: 20) {
                ForEach(items, id:\.title) {item in
                    itemView(title: item.title, detail: item.detail)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(secondaryColor)
            Spacer()
        }
        .customBackView {
            Image("backArrow")
        }
        .navigationTitle("账单详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("search_delete")
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(primaryColor)
    }
    
    @ViewBuilder private func itemView(title: String, detail: String) -> some View {
        HStack(spacing: 28) {
            Text(title)
                .textSett(color: titleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: 1)
                .frame(maxWidth: 52, alignment: .leading)
            Text(detail)
                .textSett(color: subTitleColor, FName: .PingFangSCRegular, Fsize: 13, lineLi: 1)
        }
    }
}

struct BillItemDetialView_Previews: PreviewProvider {
    static var previews: some View {
        BillItemDetialView()
    }
}
