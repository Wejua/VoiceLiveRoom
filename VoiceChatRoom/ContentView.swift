//
//  ContentView.swift
//  VoiceChatRoom
//
//  Created by weijie.zhou on 2023/4/13.
//

import SwiftUI

let placeHolderColor = "#1F265F".color(alpha: 0.6)!

let tintColor = "#FCCC46".color!
let onTintColor = "#311D08".color!
let tintBackground = "#FCCC46".color!.opacity(0.1)

let titleColor = Color.white
let subTitleColor = Color.white.opacity(0.6)
let captionColor = Color.white.opacity(0.5)

let primaryColor = "#050017".color!
let secondaryColor = "#191527".color!
let tertiaryColor = "#1E1A2E".color!

struct ContentView: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        GeometryReader { geo in
            if store.user.apiToken != nil {
                TabBarView()
                    .onAppear {
                        print("apiToken: \(otherHeader["apiToken"] ?? "00")")
                        print("userId: \(Store.shared.user.uid)")
                    }
            } else {
                OneClickLoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
