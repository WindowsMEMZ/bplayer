//
//  ContentView.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI
import AVFoundation

@available(watchOS 10, *)
public struct LSContentView: View {
    @State var videoUrl: String
    @State var videoBvid: String
    @State/*Object*/
    var videoLoader:BiliPlayer = BiliPlayer()
    @State
    var videoData:NormalBV = NormalBV()
    @State
    var player:AVPlayer = AVPlayer()
    
    @State var showInitLoading = true
    @State var isShowBlur = false
    @ViewBuilder
    func loadingView() -> some View {
        VStack {
//            if videoLoader.show初次屏 {
//                Text("正在缓存视频")
//            }
        }
    }
    @State var startedLoading = false
    @Environment(\.dismiss) var dismiss
    public init(videoUrl: String, videoBvid: String, videoLoader: BiliPlayer = BiliPlayer(), videoData: NormalBV = NormalBV(), player: AVPlayer = AVPlayer(), showInitLoading: Bool = true, isShowBlur: Bool = true, startedLoading: Bool = false) {
        self._videoUrl = State(initialValue: videoUrl)
        self._videoBvid = State(initialValue: videoBvid)
        self.videoLoader = videoLoader
        self.videoData = videoData
        self.player = player
        self.showInitLoading = showInitLoading
        self.isShowBlur = isShowBlur
        self.startedLoading = startedLoading
    }
    
    public var body: some View {
        VStack {
            if startedLoading {
                if let player = videoLoader.player {
                    VideoPlayerPlus(showBlur: $isShowBlur, mod: videoData, avplayer: player, listItems: {
                        EmptyView()
                    })
                    .overlay(content: {
                        loadingView()
                    })
                } else {
                    Text("加载中")
                }
            }
//            VideoPlayerPlus(showBlur: $videoLoader.show初次屏, mod: videoData, avplayer: player, listItems: {
//                Text("在这里插入更多视图")
//            })
//            .overlay(content: {
//                loadingView()
//            })
        }
        .onAppear {
            startedLoading = true
            let videoURL = URL(string: videoUrl)!
            let asset = AVURLAsset(url: videoURL, options: ["AVURLAssetHTTPHeaderFieldsKey": ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15", "platform": "html5", "Referer": "https://www.bilibili.com/video/\(videoBvid)"]])
            videoLoader.安排播放器(with: .init(asset: asset))
            videoLoader.finishedLoading = {
                printLog("视频可以开始播放")
            }
        }
        .onDisappear {
            bili暂停播放.send()
        }
        .onReceive(exitPlayerbuttonTapped) { _ in
            dismiss()
        }
    }
}

