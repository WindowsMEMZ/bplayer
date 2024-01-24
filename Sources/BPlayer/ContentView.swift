//
//  ContentView.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject
    var videoLoader:BiliPlayer = BiliPlayer()
    @State
    var videoData:NormalBV = NormalBV()
    @State
    var player:AVPlayer = AVPlayer()
    @State var showInitLoading = true
    @ViewBuilder
    func loadingView() -> some View {
        VStack {
            if videoLoader.show初次屏 {
                Text("正在缓存视频")
            }
        }
    }
    @State var startedLoading = false
    var body: some View {
        VStack {
            if startedLoading {
                if let player = videoLoader.player {
                    VideoPlayerPlus(showBlur: $videoLoader.show初次屏, mod: videoData, avplayer: player, listItems: {
                        Text("在这里插入更多视图")
                    })
                    .overlay(content: {
                        loadingView()
                    })
                } else {
                    Text("加载中")
                }
            } else {
                Button("开始加载视频", action: {
                    startedLoading = true
                    let videoURL = URL(string: "https://mpv.videocc.net/cf786c7a80/9/cf786c7a80f0a0a49e77f45d48aabde9_2.mp4?pid=1705814617644X1066575")!
                    videoLoader.安排播放器(with: .init(url: videoURL))
                    videoLoader.finishedLoading = {
                        printLog("视频可以开始播放")
                    }
                })
            }
        }
        
    }
}

#Preview {
    ContentView()
}
