//
//  MomentsView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/14.
//

import SwiftUI
import SwiftUITools

struct MomentsView: View {
    enum Tab {
        case following
        case recommend
    }
    @State private var currentTab: Tab = .recommend
//    @StateObject var store = Store.shared
    @State var momentListModel: MomentsListModel?
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(spacing: 0) {
                HStack(spacing: 12*factor) {
                    Text("关注")
                        .frame(width: 60*factor, height: 28*factor)
                        .foregroundColor(currentTab == .following ? "#FCCC46".color : .white)
                        .background(currentTab == .following ? "#FCCC46".color(alpha: 0.1) : "#37353C".color)
                        .cornerRadius(14*factor)
                        .onTapGesture {
                            currentTab = .following
                        }
                    Text("推荐")
                        .foregroundColor(currentTab == .recommend ? "#FCCC46".color : .white)
                        .frame(width: 60*factor, height: 28*factor)
                        .background(currentTab == .recommend ? "#FCCC46".color(alpha: 0.1) : "#37353C".color)
                        .cornerRadius(14*factor)
                        .onTapGesture {
                            currentTab = .recommend
                        }
                    Spacer()
                }
                .font(name: .PingFangSCMedium, size: 14)
                .padding(.leading, 16*factor)
                .padding(.top, 7*factor)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ImageAndTextMoment(factor: factor)
                            .onTapGesture {
                                Store.shared.navigationPath.append("momentDetail")
                            }
                        VideoMoment(factor: factor)
                            .onTapGesture {
                                Store.shared.navigationPath.append("momentDetail")
                            }
                        TextMoment(factor: factor)
                            .onTapGesture {
                                Store.shared.navigationPath.append("momentDetail")
                            }
                        TwoSmallImageMoment(factor: factor)
                            .onTapGesture {
                                Store.shared.navigationPath.append("momentDetail")
                            }
                    }
                }
                .padding(.top, 7*factor)
                .onAppear {
                    Task {
                        momentListModel = try await API.IM.momentsList(gender: nil, keyword: nil, page: 1, type: nil, uid: nil)
                    }
                }
                .refreshable {
                    Task {
                        momentListModel = try await API.IM.momentsList(gender: nil, keyword: nil, page: 1, type: nil, uid: nil)
                    }
                }
                
            }
            .frame(width: geo.size.width)
            .background("#050017".color)
            .ignoresSafeArea()
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                Image("postMoment")
                    .offset(x:-16*factor, y: -(71*factor))
                    .onTapGesture {
                        Store.shared.navigationPath.append("postMoment")
                    }
            }
        }
    }
    
}

struct MomentsView_Previews: PreviewProvider {
    static var previews: some View {
        MomentsView()
    }
}
