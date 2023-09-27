//
//  BlackUserModel.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/6/10.
//

import Foundation

struct BlackUserModel: Codable {
    var gender: Gender
    var isFans: Int
    var avatar: String
    var uidRel: Int
    var age: Int
    var username: String
}
