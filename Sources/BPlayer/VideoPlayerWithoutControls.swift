//
//  VideoPlayerWithoutControls.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import Foundation
//
//  无控件播放器.swift
//  WatchBili Watch App
//
//  Created by 凌嘉徽 on 2023/9/18.
//

import Foundation
//
//  CleanVideo.swift
//  DigtialCrownVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2023/9/1.
//

import Foundation
import Combine
import SwiftUI
import AVKit
import AVFoundation

let publisher1 = PassthroughSubject<Void, Never>()
let publisher2 = PassthroughSubject<Void, Never>()
let publisher3 = PassthroughSubject<Void, Never>()
let publisher4 = PassthroughSubject<Void, Never>()
let publisher5 = PassthroughSubject<Void, Never>()
let publisher6 = PassthroughSubject<Void, Never>()

let zipped = publisher1.zip(publisher2).zip(publisher3).zip(publisher4).zip(publisher5).zip(publisher6)


struct VideoPlayerLS: View {
    var player:AVPlayer
    var allowExpensive = true
    @State var showText = false
    @State private var videoPlayerStatusChecker = Timer.publish(every: 3, tolerance: 2, on: .main, in: .default).autoconnect()
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    // KVO观察者
    @State private var playerItemStatusObserver: NSKeyValueObservation?
    var body: some View {
        ZStack {
            VideoPlayer(player: player,videoOverlay: {
          
            })
            .allowsHitTesting(false)
        }
            .onReceive(timer, perform: { _ in
                player.currentItem?.canUseNetworkResourcesForLiveStreamingWhilePaused = true
                //清理播放器组件的按钮
                LSUI注入ForVideoPlayer.修改标题颜色(color: .red)
            })
            .onReceive(zipped, perform: { _ in
                timer.upstream.connect().cancel()
            })
            .onReceive(videoPlayerStatusChecker, perform: { _ in
                if let playerItem = player.currentItem {
                    videoPlayerStatusChecker.upstream.connect().cancel()
                    // 添加KVO观察者
                        playerItemStatusObserver = playerItem.observe(\.status, options: [.new, .old], changeHandler: { (item, change) in
                            if item.status == .failed {
                                if let error = item.error {
                                    showText = true
                                }
                            }
                        })
                }
            })
            .onDisappear {
                playerItemStatusObserver?.invalidate()
                   playerItemStatusObserver = nil
            }
         
    }
}

import Combine

//var vcT:NSObject? = nil
//let pageChangeToken = CurrentValueSubject<NSObject?,Never>(nil)
class LSUI注入ForVideoPlayer {
  
    ///请在页面变化时调用
    static func 修改标题颜色(color:UIColor) {
        let UIApplication = NSClassFromString("UIApplication") as? NSObject.Type
        let vc1 = topViewController(controller: nil)?.view()
        
       
        if let views = vc1 {
            
            let app = views
            traverseSubviews(view: app, color: color)
        }
    }
    private static func topViewController(controller:NSObject?) -> NSObject? {
        if let controller {
            if let presented = controller.presentedViewController() {
                return topViewController(controller: presented)
            }
            return controller
        } else {
            let UIApplication = NSClassFromString("UIApplication") as? NSObject.Type
            let controller = UIApplication?.sharedApplication()?.keyWindow()?.rootViewController()
            return topViewController(controller: controller)
        }
    }
    private static func traverseSubviews(view: NSObject,color:UIColor) {
        for subview in view.subviews()! {
            var allSubviews = [NSObject]()
            let app = subview
            //printLog(app)
            //print(type(of: app))
            if "\(app)".contains("AVPlayPauseButton") {
                printLog("找到了暂停按钮")
                app.setAlpha(0)
                publisher1.send()
//                app.setTextColor(color)
            }
            if "\(app)".contains("UIImageView") {
                if ("\(app.layer())").contains("; 198 43);") {
                    app.setAlpha(0)
                }
                publisher2.send()
            }
            if "\(app)".contains("AVSlider") {
                app.setAlpha(0)
                publisher3.send()
            }
            if "\(app)".contains("AVDoneButton") {
                app.setAlpha(0)
                publisher4.send()
            }
            if "\(app)".contains("AVTimeLabel") {
                app.setAlpha(0)
                publisher5.send()
            }
            if "\(app)".contains("NMUVolumeIndicatorControl") {
                app.setAlpha(0)
                publisher6.send()
            }
            
//
//            if "\(app)".contains("_PUICBuiltinBackButtonItemView") {
//
//                if vcT != app {
//
//                    //printLog("有新的推出")
//                    //app.setTag(UUID().hashValue)
//
//                    vcT = app
//                    pageChangeToken.send(app)
//                }
//                app.subviews()?.first?.setTintColor(color)
//                app.setTintColor(color)
//            }
            
            allSubviews.append(subview)
            traverseSubviews(view: subview, color: color)
        }
    }
}

