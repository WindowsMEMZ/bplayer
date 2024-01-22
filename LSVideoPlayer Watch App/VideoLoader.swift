//
//  VideoLoader.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import Foundation
import AVFoundation
import AVKit
import SwiftUI
class BiliPlayer: ObservableObject {
    
    // MARK: - AVPlayer本体
    @Published var player:AVPlayer?
    @Published var playerItem:AVPlayerItem?
    
    @Published var show初次屏 = true
    @Published var showBackButton = true
    @Published var fpFailedToLoading = false
    @Published var showLoadingUI = false
    
    func 安排播放器(with item:AVPlayerItem) {
        player = .init(playerItem: item)
        observeBackButton(of: player!)
        
        observeBuffering(of: item)
        observeLoadingFail(with: item)
    }
    
    deinit {
        playerItem = nil
        player = nil
    }
    
    
    
    // MARK: - 返回按钮
    
    var backButtonObserver: NSKeyValueObservation?
    func observeBackButton(of player:AVPlayer) {
        backButtonObserver = player.observe(\.timeControlStatus, options: [.initial,.new,.old]) { [self] obj,value in
            showBackButton = (obj.timeControlStatus != .playing)
        }
    }
    
    // MARK: - 加载失败监视
    var 加载状态观察器: NSKeyValueObservation?
    
    var finishedLoading = {}
    var run = true
  
    func observeLoadingFail(with item:AVPlayerItem) {
        加载状态观察器 =
        item.observe(\.status, options:  [.new, .old]) { [self] (playerItem, change) in
            if item.status == .failed {
                fpFailedToLoading = true
            }
            if item.status == .readyToPlay {
                withAnimation(.easeIn) {
                    show初次屏 = false
                }
                if run {
                    run = false
                    finishedLoading()
                }
            }
        }
    }
    
    // MARK: - 卡顿监视
    var playbackLikelyToKeepUpKeyPathObserver: NSKeyValueObservation?
    var playbackBufferEmptyObserver: NSKeyValueObservation?
    var playbackBufferFullObserver: NSKeyValueObservation?
    func observeBuffering(of item:AVPlayerItem) {
        playbackBufferEmptyObserver = item.observe(\.isPlaybackBufferEmpty, options: [.new]) { (_, _) in
            // show buffering
            self.showLoadingUI = true
        }
        
        playbackLikelyToKeepUpKeyPathObserver = item.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { (_, _) in
            // hide buffering
            self.showLoadingUI = false
        }
        
        playbackBufferFullObserver = item.observe(\.isPlaybackBufferFull, options: [.new]) { (_, _) in
            // hide buffering
            self.showLoadingUI = false
        }
        
    }
    
}
