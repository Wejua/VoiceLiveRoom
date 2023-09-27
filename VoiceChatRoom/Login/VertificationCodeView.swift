//
//  VertificationCodeView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI
import SwiftUITools

struct VertificationCodeView: View {
    var phoneNumber: String
    @State private var stringCode: String = ""
    @FocusState private var focusState: Bool
    @Binding var path: [OneClickLoginView.LoginViewDestiantion]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var digitCount = 4
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(alignment: .leading, spacing:0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("手机号码登录")
                        .font(name: .PingFangSCSemibold, size: 24*factor)
                        .foregroundColor(.white)
                        .padding(.top, 158*factor)
                    
                    Text("验证码已发至 \(phoneNumber)")
                        .font(name: .PingFangSCRegular, size: 14*factor)
                        .foregroundColor("FFFFFFAA".color)
                        .padding(.top, 6*factor)
                }
                .padding(.leading, 20*factor)
                
                ZStack {
                    textField(factor: factor)
                        .onAppear {
                            focusState = true
                        }
                    
                    HStack(spacing: 8*factor) {
                        ForEach(0..<digitCount, id: \.self) { index in
                            let da = getDigitString(index: index)
                            digitItem(digit: da.digit, factor: factor, isSelected: index == da.count)
                        }
                    }
                }
                .padding(.top, 38*factor)
                
                Spacer()
            }
            .frame(width: geo.size.width)
            .background("#010209FF".color)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("backArrow")
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder func textField(factor: CGFloat) -> some View {
        TextField("", text: $stringCode)
            .textFieldStyle(.plain)
            .textSelection(.disabled)
            .focused($focusState)
            .keyboardType(.numberPad)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .foregroundColor(.clear)
            .tint(.clear)
            .frame(height: 48*factor)
            .onChange(of: stringCode) { newValue in
                let length = newValue.lengthOfBytes(using: .utf8)
                if length == digitCount {
                    focusState = false
                    Task { @MainActor in
                        let model = try await API.Login.loginWithPhoneNum(phoneNum: phoneNumber, stringCode: stringCode)
                        guard let userInfo = model.data?.userInfo else {return}
                        userInfo.phoneNum = phoneNumber
                        if model.data?.event == "login" && model.data?.userInfo.gender != .unknow {
                            Store.shared.user = userInfo
                        } else {
                            path.append(.basicPersonalInfoFillingView(userInfo: userInfo))
                        }
                    }
                } else if length > digitCount {
                    stringCode = String(stringCode.prefix(digitCount))
                }
            }
    }
    
    private func getDigitString(index: Int) -> (digit: String, count: Int) {
        var digit: String
        let characters = [Character](stringCode)
        if index < characters.count {
            digit = String(characters[index])
        } else {
            digit = ""
        }
        return (digit, characters.count)
    }
    
    private func digitItem(digit: String, factor: CGFloat, isSelected: Bool) -> some View {
        Text(digit)
            .font(name: .PingFangSCRegular, size: 18*factor)
            .foregroundColor(.white)
            .frame(width: 48*factor, height: 48*factor)
            .background("#282828FF".color)
            .cornerRadius(12*factor, corners: .allCorners)
            .allowsHitTesting(false)
            .ifdo(isSelected) { view in
                view.overlay {
                    RoundedRectangle(cornerRadius: 12*factor)
                        .stroke(style: StrokeStyle(lineWidth: 1.5))
                        .foregroundColor("#FCCC4680".color)
                }
            }
    }
}

struct VertificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VertificationCodeView(phoneNumber: "13324563425", path: .constant([OneClickLoginView.LoginViewDestiantion]()))
    }
}
