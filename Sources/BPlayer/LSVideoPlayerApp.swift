//
//  LSVideoPlayerApp.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI

@main
struct LSVideoPlayer_Watch_AppApp: App {
    @State var showAlert = false
    @State var alertMessage = ""
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(alertMessage, isPresented: $showAlert, actions: {})
                .onReceive(showToast, perform: { msg in
                    self.alertMessage = msg
                    self.showAlert = true
                })
        }
    }
}
