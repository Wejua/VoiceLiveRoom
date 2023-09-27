//
//  BasicPersonalInfoFillingView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI
import SwiftUITools

struct BasicPersonalInfoFillingView: View {
    @State private var headImageKey: String?
    @State private var headImage: UIImage?
    @State private var nickName: String = ""
    @FocusState private var nickNameFocus: Bool
    @State private var birthday: String = ""
    @State private var gender: Gender = .female
    @State private var enableOKButton: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showDatePrompt: Bool = true
    @State private var hasShowedDateText: Bool = false
    @State private var selectionDate: Date = Calendar.current.date(from: DateComponents(year: 1990, month: 8, day: 15))!
    let userInfo: LoginOrRegisterModel.UserInfoModel
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
                VStack (spacing: 0) {
                    Text("完善资料")
                        .foregroundColor(.white)
                        .font(name: .PingFangSCMedium, size: 24*factor)
                        .padding(.top, 117.5*factor)
                    
                    Text("填写真实资料不错过缘分～")
                        .foregroundColor("FFFFFFAA".color)
                        .font(name: .PingFangSCMedium, size: 14*factor)
                        .padding(.top, 7*factor)
                    
                    headImage(factor: factor)
                    .onChange(of: headImageKey) { key in
                        enableOKButton = shouldEnableOKButton()
                    }
                    .onChange(of: nickName) { name in
                        enableOKButton = shouldEnableOKButton()
                    }
                    .onChange(of: hasShowedDateText) { newValue in
                        enableOKButton = shouldEnableOKButton()
                    }
                    
                    nickNameView(factor: factor)
                        .padding(.top, 30*factor)
                    
                    birthDateView(factor: factor)
                        .padding(.top, 30*factor)
                    
                    genderView(factor: factor)
                        .padding(.top, 30*factor)
                    
                    confirmButton(factor: factor)
                    
                    Spacer()
                }
                .frame(width: geo.size.width)
                .background("#050017FF".color)
                .ignoresSafeArea()
                .customSheet(edge: .bottom, isShowing: $showDatePicker) {
                    ZStack {
                        DatePicker("", selection: $selectionDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .frame(maxWidth: 300)
                    }
                    .frame(maxWidth: .infinity)
                    .background("#050017FF".color)
                }
        }
    }
    
    func shouldEnableOKButton() -> Bool {
        let hasKey: Bool = headImageKey != nil ? true : false
        let hasNickname: Bool = nickName.count > 0 ? true : false
        let enableOKButton = hasKey && hasNickname && hasShowedDateText
        return enableOKButton
    }
    
    func confirmButton(factor: CGFloat) -> some View {
        Button {
            Task { @MainActor in
                guard let token = userInfo.apiToken else {return}
                let _ = try await API.Login.editUserInfo(token: token, imageKey: headImageKey!, nickName: nickName, birthDate: selectionDate, gender: gender.rawValue)
                Store.shared.user = userInfo
            }
        } label: {
            ZStack {
                Capsule(style: .continuous)
                    .fill(enableOKButton ? "#FCCC46FF".color! : "#FCCC4688".color!)
                    .frame(width: 280*factor, height: 49*factor)
                Text("确定")
                    .foregroundColor("#311D08FF".color)
                    .font(name: .PingFangSCMedium, size: 15*factor)
            }
        }
        .padding(.top, 80*factor)
        .disabled(!enableOKButton)
    }
    
    func headImage(factor: CGFloat) -> some View {
        PickOneImage {
            Image("cameraIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90*factor, height: 90*factor)
                .overlay {
                    if let headImage = self.headImage {
                        Image(uiImage: headImage)
                            .resizable().scaledToFill()
                            .frame(width: 90*factor, height: 90*factor)
                            .clipShape(Circle())
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Image("cameraIcon_selected")
                }
                .padding(.top, 59*factor)
        } completion: { image in
            self.headImage = image
            self.nickNameFocus = false
            Task {
                let headImageKey = try await API.Login.uploadImage(image: image)
                self.headImageKey = headImageKey
            }
        }
    }
    
    private func nickNameView(factor: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("昵称")
                .foregroundColor("ffffffaa".color)
                .font(name: .PingFangSCSemibold, size: 12*factor)
            ZStack {
                Capsule(style: .continuous)
                    .fill("#282828FF".color!)
                    .frame(width: 215*factor, height: 45*factor)
                TextField("", text: $nickName, prompt: Text("请输入昵称吧").foregroundColor("ffffff33".color))
                    .frame(width: 180*factor, height: 45*factor)
                    .foregroundColor(.white)
                    .tint(.white)
                    .focused($nickNameFocus)
            }
            .padding(.leading, 15.5*factor)
        }
//        .overlay(alignment: .trailing) {
//            Image("refreshIcon")
//                .resizable()
//                .frame(width: 17*factor, height: 17*factor)
//                .padding(.trailing, 15*factor)
//        }
    }
    
    private func birthDateView(factor: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("生日")
                .foregroundColor("ffffffaa".color)
                .font(name: .PingFangSCSemibold, size: 12*factor)
            ZStack {
                Capsule(style: .continuous)
                    .fill("#282828FF".color!)
                    .frame(width: 215*factor, height: 45*factor)
                    .overlay(alignment: .leading) {
                        if showDatePrompt {
                            Text("点击选择")
                                .textSett(color: "ffffff33".color!, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                                .padding(.leading, 20*factor)
                        }
                        if hasShowedDateText {
                            let dateformatter = DateFormatter()
                            let _ = dateformatter.dateFormat = "yyyy-MM-dd"
                            Text("\(dateformatter.string(from: selectionDate))")
                                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                                .padding(.leading, 20*factor)
                        }
                    }
                    .overlay(alignment: .trailing) {
                        Image("mine_rightArrow")
                            .padding(.trailing, 10*factor)
                    }
                    .onTapGesture {
                        showDatePicker.toggle()
                        showDatePrompt = false
                        hasShowedDateText = true
                        self.nickNameFocus = false
                    }
            }
            .padding(.leading, 15.5*factor)
        }
    }
    
    private func genderView(factor: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("性别")
                .foregroundColor("ffffffaa".color)
                .font(name: .PingFangSCSemibold, size: 12*factor)
            HStack(spacing: 15*factor) {
                Button {
                    self.gender = .male
                    self.nickNameFocus = false
                } label: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill(getMaleColor(gender: gender).background)
                            .frame(width: 100*factor, height: 45*factor)
                        Text(gender == .male ? "男生👦" : "男生")
                            .foregroundColor(getMaleColor(gender: gender).textColor)
                            .font(name: .PingFangSCRegular, size: 14*factor)
                    }
                }
                .disabled(gender == .male)
                Button {
                    self.gender = .female
                    self.nickNameFocus = false
                } label: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill(getFemaleColor(gender: gender).background)
                            .frame(width: 100*factor, height: 45*factor)
                        Text(gender == .female ? "女生👧" : "女生")
                            .foregroundColor(getFemaleColor(gender: gender).textColor)
                            .font(name: .PingFangSCRegular, size: 14*factor)
                    }
                }
                .disabled(gender == .female)
            }
            .padding(.leading, 15.5*factor)
        }
    }
    
    private func getMaleColor(gender: Gender) -> (background: Color, textColor: Color) {
        if gender == .female {
            return ("#282828FF".color!, Color.white)
        } else {
            return (Color.white, "#050017FF".color!)
        }
    }
    
    private func getFemaleColor(gender: Gender) -> (background: Color, textColor: Color) {
        if gender == .male {
            return ("#282828FF".color!, Color.white)
        } else {
            return (Color.white, "#050017FF".color!)
        }
    }
}

struct BasicPersonalInfoFillingView_Previews: PreviewProvider {
    static var previews: some View {
        BasicPersonalInfoFillingView(userInfo: LoginOrRegisterModel.UserInfoModel(uid: 123, userName: "cc"))
    }
}
