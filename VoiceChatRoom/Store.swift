//
//  Store.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/17.
//

import Foundation
import SwiftUI

let userInfoKey = "userInfoKey"

class Store: ObservableObject {
    static let shared = Store()
    
    @Published var user = getUserInfo() {
        willSet {
            guard let data = try? JSONEncoder().encode(newValue) else {return}
            UserDefaults.standard.set(data, forKey: userInfoKey)
        }
    }
    
    @Published var navigationPath = NavigationPath()
    
    
    func loginOut() {
        let user = self.user
        user.apiToken = nil
        self.user = user
    }
    
}

extension Store {
    static func getUserInfo() -> LoginOrRegisterModel.UserInfoModel {
        guard let data = UserDefaults.standard.data(forKey: userInfoKey) else {return LoginOrRegisterModel.UserInfoModel(uid: 0, userName: "")}
        do {
            let userInfo = try JSONDecoder().decode(LoginOrRegisterModel.UserInfoModel.self, from: data)
            return userInfo
        } catch {
            return LoginOrRegisterModel.UserInfoModel(uid: 0, userName: "")
        }
    }
}
