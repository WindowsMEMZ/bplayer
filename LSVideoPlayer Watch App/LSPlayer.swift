//
//  LSPlayer.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI
//
//  播放器V2.swift
//  WatchBili Watch App
//
//  Created by 凌嘉徽 on 2023/9/18.
//

import Foundation
//
//  ContentView.swift
//  DigtialCrownVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2023/9/1.
//
//小Tips：双指取消进度调节
import SwiftUI
import AVFoundation
import AVKit

extension NSObject {
    //避免普通项目冲突
    @objc class func sharedApplication() -> NSObject? { fatalError() }
    
}
//var avplayer = AVPlayer(url: .init(string: "https://video19.ifeng.com/video09/2022/11/22/p7000694441719635968-102-134025.mp4?reqtype=tsl")!)
import Combine
let videoTapped = PassthroughSubject<Void, Never>()
let showToast = PassthroughSubject<String, Never>()
class LopperOS10 {
    @AppStorage("choicedVideoPlaySpeed") var
    choicedSpeed: Double = 1.0
    var avplayer:AVPlayer = .init()

    @objc func playerItemDidReachEnd(notification: Notification) {
        // 重新开始播放
        avplayer.seek(to: CMTime.zero)
        avplayer.playImmediately(atRate: Float(choicedSpeed))
        printLog("PlayV1")
    }
    @objc func playerItemDidReachEndToast(notification: Notification) {
        showToast.send("已播放到本视频结尾")
        
    }
}
enum 播放器画布:Int,Codable {
    case 正常 = 1
    case 全屏 = 2
    mutating func toggle() {
        if self == .正常 {
            self = .全屏
        } else {
            self = .正常
        }
    }
}

extension View {
    @ViewBuilder
    func ifos9(_ action:(Self)->(some View)) -> some View {
        action(self)
    }
}

extension View {
    @ViewBuilder
    func dynamicScrollView(vertical:Bool,w:Double,h:Double) -> some View {
        if vertical {
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        self
                    } .frame(width: w, height: h, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                
            })
        } else {
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack {
                    self
                } .frame(width: w, height: h, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            })
        }
    }
}

import Combine

//var vcT:NSObject? = nil
//let pageChangeToken = CurrentValueSubject<NSObject?,Never>(nil)
var 播放器音量:Float = 0.5
class LSUI注入ForVolume {
    
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
            if "\(app)".contains("NMUVolumeControlsView") {
                printLog("找到了暂停按钮")
                app.setValue(播放器音量)
                //                app.setAlpha(0)
                //                publisher1.send()
                //                app.setTextColor(color)
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

@Observable
class NormalBV {
    var enableFlyComment:Bool = false
    //用于弹幕下载
    var currentCid:Int64 = 0
}
@available(watchOS 10, *)
struct VideoPlayerPlus<V:View>: View {
    @Binding var showBlur:Bool
    //这里是进入菜单功能
    //关键词⬇️
    //进入菜单
    
    //这是双击缩放功能
    //关键词⬇️
    //缩放支持
    //自动居中
    
    var body: some View {
        ZStack {
            ZStack {
                ZStack {
                    ZStack {
                        ZStack {
                            ScrollViewReader(content: { proxy in
                                
                                ZStack {
                                    
                                    Group {
                                        
                                        ZStack {
                                            Color.black
                                            VideoPlayerLS(player: avplayer)
                                                .opacity(brightness)
                                            Color.touchZone
                                                .resizable()
                                                .if(doubleTaoMod.BiliPlayerDoubleTapAction != .禁用) { v in
                                                    v
                                                        .onTapGesture(count: 2, perform: {
                                                            printLog("点击我")
                                                            switch doubleTaoMod.BiliPlayerDoubleTapAction {
                                                            case .禁用:
                                                                break
                                                            case .放大缩小:
                                                                激活 = false
                                                                playerSize.toggle()
                                                            case .暂停继续:
                                                                bili暂停播放.send()
                                                            }
                                                        })
                                                }
                                            
                                                .beButton {
                                                    if doubleTaoMod.BiliPlayerDoubleTapAction != .禁用 {
                                                      
                                                    }
                                                    videoTapped.send()
                                                }
                                                .buttonStyle(.plain)
                                            HStack {
                                                Spacer()
                                                Color.clear
                                                    .frame(width: 1, height: 100, alignment: .center)
                                                    .readPosition(in: .named("播放器"), onChange: { rect in
                                                        position = (rect.maxX - screenBound.width)
                                                    })
                                                    .overlay(content: {
                                                        Color.clear
                                                            .frame(width: 100, height: 100, alignment: .center)
                                                            .overlay(content: {
                                                                HStack {
                                                                    Spacer()
                                                                    VStack {
                                                                        HStack {
                                                                            Image(systemName: "chevron.right")
                                                                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                                                                            Spacer()
                                                                        }
                                                                        Text("继续右滑进入菜单")
                                                                    }.padding(.leading)
                                                                        .frame(width: 50, height: 100, alignment: .center)
                                                                    
                                                                }
                                                            })
                                                    })
                                            }
                                        }
                                        
                                    }
                                    //缩放支持
                                    //横向滚动支持覆层
                                    HStack {
                                        Color.red
                                            .hidden()
                                            .id("CENT1")
                                        Color.blue
                                            .hidden()
                                            .frame(width: 1)
                                            .id("CENT")
    //                                        .tag("CENT")
                                        Color.red
                                            .hidden()
                                            .id("CENT2")
                                    }
                                    .opacity(0.2)
                                    .allowsHitTesting(false)
                                }
                               
                                .dynamicScrollView(vertical: isVertical, w: w, h: h)
                                .onLoad(操作: {
                                    //自动居中
                                    self.scollTOCent = {
                                        withAnimation(.easeInOut) {
                                            proxy.scrollTo("CENT", anchor: .center)
                                        }
                                    }
                                })
                            })
                            //进入菜单
                            .onChange(of: position, perform: { value in
                                if 激活 {
                                    if showMenu.not {
                                        if position < -gestureH {
                                            if 忽略一次 {
    //                                            忽略一次 = false
                                                printLog("忽略菜单")
                                            } else {
                                                printLog("进入菜单")
                                                设定showCurrentDateTime.send(true)
                                                withAnimation(.smooth) {
                                                    showMenu = true
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    激活 = true
                                }
                            })
                            //                    音量调节视图()
                            //                        .onReceive(音量timer, perform: { _ in
                            //                            LSUI注入ForVolume.修改标题颜色(color: .red)
                            //                        })
                            if #available(watchOS 10, *) {
                                if mod.enableFlyComment {
                                    仅添加弹幕(player: avplayer,videoCid:$mod.currentCid)
                                }
                            }
                            ControlView(showMenu:$showMenu,player:avplayer,volume: $volume, showLB: $showLB,crownVideoProgress: $crownVideoProgress)
                        }
                        .blur(radius: showTouzone ? 23 : 0)
                        ZStack {
                            Color.touchZone
                            Text("点击开始播放"+moreText)
                        }
                        .opacity(showTouzone ? 1 : 0)
                        .allowsHitTesting(showTouzone)
                        .beButton {
                            showTouzone = false
                            avplayer.playImmediately(atRate: Float(choicedSpeed))
                            printLog("PlayV2")
                            biliPlayerAskShowDM = true
                        }
                        .buttonStyle(.plain)
                        .focusable()
                        .modifier(OS9Corwn(volume: $volume, showLB: $showLB, crownVideoProgress: $crownVideoProgress))
                    }
                    
                    .frame(width: screenBound.width, height: screenBound.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    if showMenu {
                        OverlayLS(loopingPlayback:$loopingPlayback,avplayer:avplayer,videoRatio:$videoRatio,listItems:listItems,showMenu:$showMenu)
                            .frame(width: screenBound.width, height: screenBound.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .trailing))
                    }
                    if showCurrentDateTime {
                        VStack {
                            HStack {
                                Spacer()
                                Text(Date.getCurrentTimeInMMDDFormat())
                                    .padding(.top,15)
                                    .ignoresSafeArea(.container, edges: [.trailing,.top])
                            }
                            Spacer()
                        }
                    }
                    
                }
                .blur(radius: showBlur ? 18 : 0 )
                .onChange(of: showMenu, perform: { _ in
                    if showMenu == false {
                        设定showCurrentDateTime.send(false)
                    }
                })
            }
            //🏠播放灰屏检测
            if 显示灰色 {
                VStack {
                    Label("播放失败", systemImage: "visionpro.badge.exclamationmark")
//                    Text()
                           Text("请在左上角关闭视频后")
                               .font(.footnote)
                           Text("重新进入")
                }
                .foregroundStyle(Color.accentColor.gradient)
            }
        }
        .onAppear {
            volume = Double(LionAudioToolKit.currentSystemVolume())
            
        }
        
        .syncValue(of: choicedSpeed, perform: { _ in
            avplayer.rate = Float(choicedSpeed)
        })
        //🏠播放灰屏检测
        .onReceive(errorDetechTimer, perform: { _ in
            MainActor {
                if let error = avplayer.error {
                    显示灰色 = true
                    printLog("出错了\(error)")
                } else {
                    显示灰色 = false
                }
                if let currentItem = avplayer.currentItem {
                    if let error = currentItem.error {
                        printLog("出错了\(error)")
                        显示灰色 = true
                    } else {
                        显示灰色 = false
                    }
                } else {
                    printLog("出错了：没有currentItem")
                    显示灰色 = true
                }
            }
        })
        // MARK: - 音量
        //        .syncValue(of: volume, perform: { _ in
        //            let new =  normalize(Float(volume/100),to:0...1)
        //            printLog("系统音量",new)
        //            播放器音量 = new
        //        })
        //        系统
        .syncValue(of: volume, perform: { _ in
            //🌞
//            avplayer.volume = normalize(Float(volume/100), to: 0...1)
        })
        //        .onChange(of: showLB, perform: { value in
        //            if showLB {
        //                继续音量调节()
        //            } else {
        //                暂停音量调节()
        //            }
        //        })
        .onLoad {
            暂停音量调节()
        }
//        .onAppear {
//            self.anime = mod.anime
//        }
     
        //        .syncValue(of: showMenu, perform: { _ in
        //            if showMenu {
        //                biliPlayerAskShowDM = false
        //            } else {
        //                biliPlayerAskShowDM = true
        //            }
        //        })
        .onLoad {
            biliPlayerAskShowDM = false
        }
        .onReceive(videoRatioGetter, perform: { _ in
            if let ratio = getEmuRatio(for: avplayer) {
                videoRatioGetter.upstream.connect().cancel()
                MainActor {
                    switch ratio {
                    case .方形:
                        videoRatio = .方形
                    case .横屏:
                        videoRatio = .横屏
                    case .竖屏:
                        videoRatio = .竖屏
                    }
                }
            }
        })
        .ignoresSafeArea()
        .coordinateSpace(name: "播放器")
        .syncValue(of: playerSize, perform: { _ in
            刷新尺寸()
        })
        .syncValue(of: videoRatio, perform: { _ in
            刷新尺寸()
        })
        .syncValue(of:biliPlayerLandscape, perform: { _ in
            DispatchAfter(after: 0.4, handler: {
                刷新尺寸()
            })
        })
        .onLoad {
            let h:Double = {
                let num:Double = 5
                printLog(screenBound.width/num)
                if screenBound.width/num > 44 {
                    return 44
                } else {
                    return screenBound.width/num
                }
            }()
            gestureH = h
        }
        .onLoad {
            activeCrownProgress = false
        }
        .onReceive(设定showCurrentDateTime, perform: { i in
            showCurrentDateTime = i
        })
        .syncValue(of: loopingPlayback, perform: { _ in
            if loopingPlayback {
                self.looper.avplayer = avplayer
                //when play to end,seek to start
                NotificationCenter.default.addObserver(
                     self,
                     selector: #selector(self.looper.playerItemDidReachEnd(notification:)),
                     name: .AVPlayerItemDidPlayToEndTime,
                     object: avplayer.currentItem
                 )
            } else {
                removeLooping()
                //toast only
                NotificationCenter.default.addObserver(
                     self,
                     selector: #selector(self.looper.playerItemDidReachEndToast(notification:)),
                     name: .AVPlayerItemDidPlayToEndTime,
                     object: avplayer.currentItem
                 )
                
            }
        })
    }
    @State var mod:NormalBV
    @AppStorage("showBiliDanmu") var showBiliDanmu = true
    @State var avplayer:AVPlayer
    var listItems:()->(V)
    @AppStorage("播放器画布")
    var playerSize:播放器画布 = .正常
    @State var position = 0.0
    
    @State var videoRatio:全屏按钮设定 = .未知
    @State private var 音量timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    ///``这是0到100``
    @State var volume = 50.0
    @State var showLB = false
    @State var gestureH:Double = 44
    @SceneStorage("screenBound") var screenBound = WKInterfaceDevice.current().screenBounds
    @State var h:Double = WKInterfaceDevice.current().screenBounds.height
    @State var w:Double = WKInterfaceDevice.current().screenBounds.width
    @AppStorage("brightnessV1") var brightness = 1.0
    @State var videoRatioGetter = Timer.publish(every: 1,tolerance: 1, on: .main, in: .default).autoconnect()
//    @State var anime = false
    @AppStorage("choicedVideoPlaySpeed") var
    choicedSpeed: Double = 1.0
    
    //🏠播放灰屏检测
    @State var playGaryToken:NSObjectProtocol?
    @State var 显示灰色 = false
    
    
    @State var moreText = ""
    var isVertical:Bool {
        
        switch videoRatio {
        case .未知:
            return false
        case .方形:
//            return false
            switch playerSize {
            case .正常:
                return false
            case .全屏:
                return true
            }
        case .横屏:
            return false
        case .竖屏:
            
            return true
        }
       
    }
    func 暂停音量调节() {
        音量timer.upstream.connect().cancel()
    }
    func 继续音量调节() {
        音量timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    }
    @State var crownVideoProgress = 0.0
    
    @StateObject var doubleTaoMod = BilliVideoPlayerSummerDoubleTapModel()
    @State var 激活 = true
    let onRead = PassthroughSubject<Void,Never>()
    let errorDetechTimer = Timer.publish(every: 1, tolerance: 1, on: .main, in: .default).autoconnect()

    func removeLooping() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: avplayer.currentItem
        )
    }
    @State var looper = LopperOS10()
    @State var loopingPlayback = false
    @State var showCurrentDateTime = false
    @AppStorage("ADB08689") var count = 0
    @AppStorage("activeCrownProgress") var activeCrownProgress = false
    @AppStorage("biliPlayerAskShowDM") var biliPlayerAskShowDM = true
    @State var startCoverTap = false
    @AppStorage("biliPlayerLandscape") var biliPlayerLandscape = false
    func getEmuRatio(for avPlayer: AVPlayer) -> EmuRatio? {
        if let playerItem = avPlayer.currentItem,
           let videoTrack = playerItem.asset.tracks(withMediaType: .video).first {
            let naturalSize = videoTrack.naturalSize
            let videoRatio = naturalSize.width / naturalSize.height
            
            if videoRatio == 1.0 {
                return .方形
            } else if videoRatio > 1.0 {
                return .横屏
            } else {
                return .竖屏
            }
        }
        
        // 如果无法获取到AVPlayerItem或视频轨道，则返回空
        return nil
    }
    enum EmuRatio: Int {
        case 方形 = 1
        case 横屏 = 2
        case 竖屏 = 3
    }
    @State var 忽略一次 = false
    
//    func withAnimation(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows {
//
//    }

    func 恢复() {
       
        withAnimation(.smooth) {
            h = screenBound.height
            w = screenBound.width
        } completion: {
            忽略一次 = false
        }
    }
    
    //缩放支持
    @State var scollTOCent:()->() = {}
    
    //缩放支持
    func 刷新尺寸() {
        忽略一次 = true
        
        
        
        switch playerSize {
        case .正常:
            恢复()
            
            break
        case .全屏:
            switch videoRatio {
            case .未知:
              恢复()
                break
            case .方形:
               恢复()
                break
            case .横屏:
                
                withAnimation(.smooth) {
                    w = screenBound.height/9*16
                   
                } completion: {
                    
                    忽略一次 = false
                    scollTOCent()
                }
            case .竖屏:
                
                withAnimation(.smooth) {
                    h = screenBound.width/9*16
                    
                } completion: {
                    忽略一次 = false
                }
            }
        }
    }
    @State var showMenu = false
    @State var showTouzone = true
}
let 设定showCurrentDateTime = PassthroughSubject<Bool,Never>()
enum 全屏按钮设定 {
    case 未知
    case 方形
    case 横屏
    case 竖屏
}
var cancellableTaskKFCV91 = CancellableTask()
class 进度条滚动模型 {
    static var shared = 进度条滚动模型()
    var 总滚动量 = 10000.0
    var 倍率 = 10.0
    var 中间位置 = 500.0
    var 倍率压缩后的中间位置 = 50.0
}
struct OS9Corwn: ViewModifier {
    @Binding var volume:Double
    @Binding var showLB:Bool
    @Binding var crownVideoProgress:Double//加减秒数
    @State var internalProgress = 0.0
    @AppStorage("activeCrownProgress") var activeCrownProgress = false
    
    func body(content: Content) -> some View {
        VStack {
            let sesitivity:DigitalCrownRotationalSensitivity = activeCrownProgress ? .high : .medium
            if #available(watchOS 9, *) {
                content
                
                    .digitalCrownRotation($internalProgress, from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, through: activeCrownProgress ? 进度条滚动模型.shared.总滚动量 : 100, sensitivity: sesitivity, isContinuous: false, isHapticFeedbackEnabled: true, onChange: { _ in
                        showLB = true
                    }, onIdle: {
                        showLB = false
                    })
                
            } else {
                content
                    .digitalCrownRotation($internalProgress, from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, through: activeCrownProgress ? 进度条滚动模型.shared.总滚动量 : 100, sensitivity: sesitivity, isContinuous: false, isHapticFeedbackEnabled: true)
                // MARK: - 音量提示
                
            }
        }
        .syncValue(of: internalProgress, perform: { value in
            if !WKInterfaceDevice.current().systemVersion.hasPrefix("8.") {
                
            } else {
                printLog("S2")
                if 忽略表冠值调整 {
                    忽略表冠值调整 = false
                } else {
                    showLB = true
                    printLog("激活")
                    cancellableTaskKFCV91.cancel()
                    cancellableTaskKFCV91 = CancellableTask()
                    cancellableTaskKFCV91.performDelayedOperation(after: 0.1, handler: {
                        showLB = false
                        printLog("不激活")
                    })
                }
            }
        })
        .syncValue(of: activeCrownProgress, perform: { _ in
            MainActor {
                if 忽略表冠运动激活状态调整.not {
                    printLog("点击触发改变\(activeCrownProgress)")
                    刷新内部()
                } else {
                    忽略表冠运动激活状态调整 = false
                }
            }
        })
        //        .syncValue(of: volume, perform: { _ in
        //            printLog("音量触发改变")
        //            刷新内部()
        //        })
        .onChange(of: internalProgress, perform: { _ in
            if activeCrownProgress {
                self.crownVideoProgress = internalProgress/进度条滚动模型.shared.倍率
            } else {
                self.volume = internalProgress
            }
        })
        .onReceive(重置音量进度, perform: { i in
            self.internalProgress = 进度条滚动模型.shared.中间位置
            printLog("设为中间位置")
            忽略表冠值调整 = true
        })
        .onReceive(设置环为, perform: { i in
            self.internalProgress = i
            忽略表冠值调整 = true
        })
    }
    @State var 忽略表冠值调整 = false
    @State var 忽略表冠运动激活状态调整 = false
    func 刷新内部() {
        if activeCrownProgress {
            self.internalProgress = 进度条滚动模型.shared.中间位置
            printLog("设为中间位置")
        } else {
            忽略表冠值调整 = true
            self.internalProgress = volume
            printLog("设为音量")
        }
    }
}
let 设置环为 = PassthroughSubject<Double,Never>()
let 重置音量进度 = PassthroughSubject<Void,Never>()
extension View {
    @ViewBuilder
    func os9DigtialCorwn(volume:Binding<Double>,showLB:Binding<Bool>) -> some View {
        if #available(watchOS 9, *) {
            self   .digitalCrownRotation(volume, from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, through: 100, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true, onChange: { _ in
                showLB.wrappedValue = true
            }, onIdle: {
                showLB.wrappedValue = false
            })
            
        } else {
            self
                .digitalCrownRotation(volume, from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, through: 100, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
            // MARK: - 音量提示
                .onChange(of: volume.wrappedValue, perform: { value in
                    showLB.wrappedValue = true
                    cancellableTaskKFCV91.cancel()
                    cancellableTaskKFCV91.performDelayedOperation(after: 0.1, handler: {
                        showLB.wrappedValue = false
                    })
                })
        }
    }
}
extension View where Self:Shape {
    @ViewBuilder
    func os10MaterialBlue() -> some View {
        if #available(watchOS 10, *) {
            self
                .fill(Material.ultraThin)
        } else {
            self
                .fill(Color.blue.opacity(0.23))
        }
    }
}
extension View  {
    @ViewBuilder
    func os10SymbolEffect(value:Bool) -> some View {
        if #available(watchOS 10, *) {
            self
                .contentTransition(.symbolEffect(.automatic))
                .animation(.easeOut, value: value)
        } else {
            self
            
        }
    }
}
let bili暂停播放 = PassthroughSubject<Void,Never>()
let reGetFocusPublisher = PassthroughSubject<Void,Never>()

var visiulHideMenu = false

class BiliPlayerVolumeInjector {
    ///请在页面变化时调用
    static func inject() {
        let UIApplication = NSClassFromString("UIApplication") as? NSObject.Type
        let vc1 = topViewController(controller: nil)?.view()
        
        if let views = vc1 {
            let app = views
            traverseSubviews(view: app)
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
    private static func traverseSubviews(view: NSObject) {
        for subview in view.subviews()! {
            var allSubviews = [NSObject]()
            let app = subview
            if "\(app)".contains("NMUVolumeControlsView") {
                printLog("找到了NMUVolumeControlsView！")
                subview._setValue(idealSystemVolume, animated: true, sendAction: true)
            }
            allSubviews.append(subview)
            traverseSubviews(view: subview)
        }
    }
}
//
extension NSObject {
    @objc func _setValue(_ value: Float, animated: Bool, sendAction: Bool) {
        fatalError()
    }
}

var idealSystemVolume:Float = 0.5


struct RememberCloseSilentMode: View {
    
    @State var showSheet = false
    @Binding var show:Bool
    var body: some View {
        Text("记得关静音模式d(^_^o)")
            .minimumScaleFactor(0.1)
            .scaledToFit()
            .opacity(show ? 1 : 0)
            .beButton {
                showSheet = true
            }
            .frame(width: show ? .infinity : 0, height: show ? .infinity : 0, alignment: .center)
            .animation(.smooth,value:show)
            .sheet(isPresented: $showSheet,onDismiss: {
                reGetFocusPublisher.send()
            }, content: {
                ScrollView {
                    SilentModeGuilder(showSheet:$showSheet)
                    .scenePadding(.horizontal)
                }
            })
    }
}

struct SilentModeGuilder: View {
    @Binding var showSheet:Bool
    var body: some View {
        VStack {
            Text("怎么关闭静音模式？")
            Divider()
            Image(systemName: "1.circle.fill").leadingText()
            if #available(watchOS 10, *) {
                Text("按下手表侧边的长条形按钮（位于可旋转按钮旁边）")
            } else {
                Text("现在，在手表屏幕最下边缘长按，感受到震动后向上滑动")
            }
            Image(systemName: "2.circle.fill").leadingText()
            VStack {
                Text("在弹出的页面中，找到\(Image(systemName: "bell.slash.fill"))图标，点击可以切换它，把它切换到\(Image(systemName: "bell.fill"))的状态。")
            }
            Image(systemName: "3.circle.fill").leadingText()
            VStack {
                Text("您已经关闭了手表的静音模式。点我，关闭这个页面，随后继续旋转手表的侧边旋钮即可调节音量。")
            }
            .beButton {
                showSheet = false
            }
            .buttonStyle(.plain)
        }
    }
}
let exitPlayerbuttonTapped = PassthroughSubject<Void,Never>()
@available(watchOS 10, *)
struct ControlView: View {
    @Binding var showMenu:Bool
    @State var player:AVPlayer
    
    ///这是0到100
    @Binding
    var volume:Double
    @Binding
    var showLB:Bool
    @SceneStorage("screenBound")
    var screenBound = WKInterfaceDevice.current().screenBounds
    @State var showLBinner = false
    @State var showLBinnerVolume = false
    
    @State var playing = false
    @AppStorage("activeCrownProgress") var activeCrownProgress = false
    @State var loading = false
    @State var 内部 = false
    @State var token: NSKeyValueObservation?
    @State var progressTimer = Timer.publish(every: 1,tolerance: 1, on: .main, in: .default).autoconnect()
    @State var videoProgress = 0.0
    @SceneStorage("biliPlayerShowControl") var showButtons = false
    @GestureState var dragValue:Double?
    @State var lastDragValue:Double?
    @Binding var crownVideoProgress:Double//加减秒数
    
    func 恢复正常音量() {
        if let 进度前音量 {
            
            volume = 进度前音量
            设置环为.send(进度前音量)
            //                                    printLog("设置volume为",volume)
        }
    }
    @State var 进度前音量:Double?
    
    @available(watchOS 10.0, *)
    func 制作按钮<V:View>(symbol:V,action:@escaping ()->()) -> some View {
        ZStack {
            Circle()
                .fill(Material.ultraThin)
            symbol
                .imageScale(.medium)
                .bold()
        }  .frame(width: 36, height: 36, alignment: .center)
            .beButton {
                action()
            }
            .buttonStyle(.plain)
        
        
        
    }
    @AppStorage("showBiliDanmu") var openDM = true
    @Namespace var nameSpace
    func 暂停播放() {
        内部 = true
        if playing {
            player.pause()
        }
        if playing.not {
            恢复正常音量()
            player.playImmediately(atRate: Float(choicedSpeed))
            printLog("PlayV0")
        }
        playing.toggle()
    }
    @AppStorage("choicedVideoPlaySpeed") var
    choicedSpeed: Double = 1.0
    var body: some View {
        ZStack {
            
            VStack {
                TopControlView(backButtonTap: {
                    exitPlayerbuttonTapped.send()
                }, sideBarTap: {
                    withAnimation(.smooth) {
                        showMenu = true
                    }
                })
                Spacer()
                BottomControlView(playing:$playing,leadingAction: {
                    暂停播放()
                }, trillingAction: {
                    openDM.toggle()
                })
                
                VStack {
                    if let dragValue {
                        ProgressView(value: dragValue, total: 1)
                    } else {
                        ProgressView(value: videoProgress, total: 1)
                        //                           .transition(.scale(scale: 10))
                    }
                }
                .animation(.easeOut, value: dragValue)
                .frame(width: screenBound.width-23, alignment: .center).scenePadding(.vertical)
                .background {
                    Color.touchZone.resizable()
                }
                .shadow(color: activeCrownProgress ? .yellow : .clear, radius: activeCrownProgress ? 4 : 0, x: 0, y: 0)
                
                //                   .allowsHitTesting(false)
                .simultaneousGesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .named("进度条")).updating($dragValue, body: { ges,fr,_ in
                    let xNew = ges.location.x
                    //
                    let p1 = xNew/(screenBound.width-23)
                    let res = normalize(p1,to: 0...1)
                    fr = res
                })
                                     
                    .onEnded { _ in
                        if let lastDragValue,let 总时间 {
                            player.currentItem?.seek(to: CMTimeMakeWithSeconds(总时间*lastDragValue, preferredTimescale: 1))//时间精度，秒
                            //                            if let videoProgress {
                            let 拖拽时间 = ((lastDragValue-videoProgress)*总时间)
                            videoJump.send(拖拽时间)
                            //                            }
                        }
                        lastDragValue = nil
                    })
                .highPriorityGesture(
                    TapGesture()
                        .onEnded { _ in
                            //修复点击旋转进度后音量异常的问题
                            if activeCrownProgress {
                                恢复正常音量()
                            } else {
                                进度前音量 = volume
                            }
                            activeCrownProgress.toggle()
                            if activeCrownProgress {
                                player.pause()
                                重置音量进度.send()
                            }
                        }
                )
                .onChange(of: dragValue, perform: { value in
                    if let dragValue {
                        lastDragValue = dragValue
                    }
                })
                .coordinateSpace(name: "进度条")
            }.opacity(showButtons ? 1 : 0)  .frame(width: screenBound.width, height: screenBound.height, alignment: .center)
            VStack {
                if loading {
                    VStack {
                        Text("视频加载中").font(.callout.bold()).shadow(radius: 2)
                        ProgressView()
                    }
                }
            }.animation(.easeIn(duration: 0.4), value: loading).allowsHitTesting(false)
            VStack {
                //🌞
//                更大音量View(show:$showMore) {
//                    player.pause()//先避免声音
//                    showMoreVolumePage = true
//                }
                RememberCloseSilentMode(show:$showMore)
                .frame(width:screenBound.width-20,height: !showMore ? 1 : 40, alignment: .center)
                .matchedGeometryEffect(id: "MORE", in: nameSpace)
                
                //                .border(.yellow)
                .opacity(activeCrownProgress ? 0 : (showLBinnerVolume ? 1 : 0))//.border(.red)
                .animation(.smooth, value: showMore)
                VStack {
                    ZStack {
                        VStack {
                            if #available(watchOS 10, *) {
                                Circle()
                                    .fill(Material.thin)
                            } else {
                                Circle()
                                    .fill(Color.black)
                                
                                
                            }
                        }   .frame(width: 110, height: 110, alignment: .center)
                        ZStack {
                            VStack {
                                Circle()
                                    .trim(from: 0, to: volume/100)
                                    .stroke(Color.white.gradient, style: .init(lineWidth: 6, lineCap: .round, lineJoin: .round))
                            }
                            .rotationEffect(.degrees(-90))
                            
                            Image(systemName: "speaker.wave.3.fill")
                                .resizable().bold()
                                .frame(width: 56, height: 56, alignment: .center)
                        }  .frame(width: 98, height: 98, alignment: .center)
                    }
                    
                }
                //                .border(.green)
                //仅在不激活时显示
                .opacity(activeCrownProgress ? (0) : (showLBinner ? 1 : 0))
             
                .matchedGeometryEffect(id: "RING", in: nameSpace)
                //                .onChange(of: activeCrownProgress, perform: { _ in
                //                printLog("Hello")
                //                })
                .animation(.none, value: volume)
            }
            .animation(.easeInOut)
            VStack {
                ZStack {
                    VStack {
                        if #available(watchOS 10, *) {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Material.regular)
                            
                        } else {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.black.opacity(0.5))
                        }
                    }
                    VStack {
                        if crownVideoProgress > 进度条滚动模型.shared.倍率压缩后的中间位置 {
                            Text("加\(Int((crownVideoProgress-进度条滚动模型.shared.倍率压缩后的中间位置)))秒")
                        } else {
                            Text("减\(Int((进度条滚动模型.shared.倍率压缩后的中间位置-crownVideoProgress)))秒")
                        }
                    }
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                    .shadow(color: .gray, radius: 3, x: 1, y: 1)
                }
            }
            .frame(width: 88, height: 67, alignment: .center)
            //仅在激活时显示
            .opacity(activeCrownProgress ? (showLBinner ? 1 : 0) : 0)
            // MARK: - 音量调节提示
          
            .onChange(of: volume) { _ in
                let value = volume
                //🌞
                idealSystemVolume = Float(volume)/100
                BiliPlayerVolumeInjector.inject()
                if volume > 98 {
                    showMore = true
                    let volumeR = AVAudioSession.sharedInstance().outputVolume
                    if volumeR < 0.5 {
                        //🐑
                        //                                            let new = ToastMessage.init(title: "您当前的系统音量为\(String(format: "%.2f", volumeR))", subTitle: "请点我来调大",action: {
                        //                                                showMoreVolumePage = true
                        //                                            })
                        //                                            self.lastToastID = new.id
                        //                                            if let lastToastID {
                        //                                                MessageContainer.shared.removeToast(toastIDs: [lastToastID])
                        //                                                toast(new)
                        //                                            }
                    }
                } else {
                    showMore = false
                }
            }
            音量调节视图()
                .offset(y: screenBound.height)//看不见但可以找到、控制
                //🌞
                .allowsHitTesting(false)
                .disabled(true)
        }
  
        //.animation(.easeInOut)
        .onReceive(bili暂停播放, perform: { _ in
            暂停播放()
        })
        .onChange(of: showButtons, perform: { _ in
            if showButtons {
                
            } else {
                恢复正常音量()
            }
        })
        .onLoad {
            showButtons = false
        }
        .onReceive(videoTapped) { _ in
            withAnimation(.smooth) {
                showButtons.toggle()
            }
        }
        //自动取消激活
        .onChange(of: showButtons, perform: { _ in
            if showButtons {
                
            } else {
                activeCrownProgress = false
            }
        })
        .onReceive(progressTimer, perform: { _ in
            if let allTime = player.currentItem?.duration.seconds {
                if allTime.isNaN.not {
                    self.总时间 = allTime
                    let currentTime = player.currentTime().seconds
                    if currentTime.isNaN.not {
                        withAnimation(.easeOut) {
                            videoProgress = currentTime/allTime
                        }
                    }
                }
            }
        })
        .onChange(of: playing, perform: { value in
            if playing {
                cancellableTask1.performDelayedOperation(after: 0.5) {
                    withAnimation(.easeInOut) {
                        showButtons = false
                    }
                    
                }
            }
            if playing.not {
                
                cancellableTask1.cancel()
                withAnimation(.easeOut(duration: 0.2)) {
                    showButtons = true
                }
            }
        })
        .onLoad {
            //用于耳机控制
            token = player.observe(\.timeControlStatus, changeHandler: { myPlayer,_ in
                if (myPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
                    loading = true
                } else {
                    loading = false
                }
                if 内部 {
                    内部 = false
                } else {
                    MainActor {
                        playing = (myPlayer.timeControlStatus == .playing)
                        printLog("变啦\(playing)")
                    }
                }
            })
        }
        .onReceive(reGetFocusPublisher, perform: { _ in
            reGetFocus()
        })
        .frame(width: screenBound.width, height: screenBound.height, alignment: .center)
        .syncValue(of: showLB, perform: { _ in
            if showLB {
                cancellableTask.cancel()
                cancellableTask2.cancel()
                withAnimation(.easeOut) {
                    showLBinner = true
                    showLBinnerVolume = true
                }
            }
            if showLB.not {
                cancellableTask.performDelayedOperation(after: 0.33) {
                    结算时间变化()
                    
                    if activeCrownProgress {
                        重置音量进度.send()
                        showLBinner = false
                    } else {
                        withAnimation(.easeOut) {
                            showLBinner = false
                        }
                    }
                }
                
                cancellableTask2.performDelayedOperation(after: 1.33) {
                    withAnimation(.easeInOut) {
                        showLBinnerVolume = false
                    }
                }
            }
        })
       //可弹窗在首页中加了
    }
    @State var lastToastID:UUID?
    func 结算时间变化() {
        if activeCrownProgress {
            if let allTime = player.currentItem?.duration.seconds {
                if allTime.isNaN.not {
                    let currentTime = player.currentTime().seconds
                    if currentTime.isNaN.not {
                        let 变化 = (crownVideoProgress - 进度条滚动模型.shared.倍率压缩后的中间位置)
                        var 新时间 = currentTime + 变化
                        if 新时间 < 0 {
                            新时间 = 0
                        }
                        if 新时间 > allTime {
                            新时间 = allTime
                        }
                        player.currentItem?.seek(to: CMTimeMakeWithSeconds(新时间, preferredTimescale: 1))//时间精度，秒
                        videoJump.send(变化)
                        //
                    }
                }
            }
            
        }
    }
    func reGetFocus() {
        visiulHideMenu = true
        showMenu = true
        DispatchAfter(after: 0.3, handler: {
            showMenu = false
            visiulHideMenu = false
        })
    }
    @State var showMore = false
    //// 使用示例
    @State var cancellableTask = CancellableTask()
    @State var cancellableTask1 = CancellableTask()
    @State var cancellableTask2 = CancellableTask()
    //
    //// 执行延迟操作
    
    //
    //// 如果需要取消操作
    
    //
    @State var 总时间:Double?
}

struct 更大音量View: View {
    @Binding var show:Bool
    var action:()->()
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack {
                Label(show ? "点我更大音量" : "", systemImage:"speaker.wave.3.fill")
            }
            .opacity(show ? 1 : 0)
        })
        .frame(width: show ? .infinity : 0, height: show ? .infinity : 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .animation(.smooth,value:show)
    }
}


//struct 弹幕View: View {
//
//    var body: some View {
//        Color.touchZone
//            .resizable()
//            .frame(width: 44, height: 44, alignment: .center)
//            .overlay(content: {
//                Text("弹").minimumScaleFactor(0.1).scaledToFit().font(.system(size: 67, weight: .thin, design: .default)).padding(1)
//            })
//            .overlay(content: {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Image(systemName: "checkmark")
//                            .imageScale(.small)
//                            .foregroundColor(openDM ? .white : .clear)
//                    }
//                }
//            })
//            .beButton {
//
//            }
//            .buttonStyle(.plain)
//    }
//
//}
@available(watchOS 10, *)
struct BottomControlView: View {
    @Binding var playing:Bool
    @AppStorage("showBiliDanmu") var openDM = true
    var leadingAction:()->()
    var trillingAction:()->()
    var body: some View {
        HStack {
            制作按钮(symbol: {
                Image(systemName: playing ? "pause.fill" : "play.fill").resizable()
                    .frame(width: 18, height: 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .os10SymbolEffect(value: playing)
            })
            .padding(.horizontal,12.5)
            .scenePadding(.vertical)
            .beButton {
                leadingAction()
            }
            .buttonStyle(.plain)
            
            .ignoresSafeArea(.container, edges: [.leading,.bottom])
            Spacer()
            if #available(watchOS 10, *) {
                制作按钮(symbol: {
                    VStack {
                        
                        Text("弹").minimumScaleFactor(0.1).scaledToFit().font(.system(size: 32, weight: .thin, design: .default)).padding(5)
                            .overlay(content: {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .imageScale(.small)
                                            .foregroundColor(openDM ? .white : .clear)
                                    }
                                }
                            })
                        
                    }
                })
                .padding(.horizontal,12.5)
                .scenePadding(.vertical)
                .beButton {
                    trillingAction()
                }
                .buttonStyle(.plain)
                .ignoresSafeArea(.container, edges: [.trailing,.bottom])
            }
        }
    }
    
    func 制作按钮<V:View>(symbol:()->(V)) -> some View {
        if #available(watchOS 10.0, *) {
            return ZStack {
                Circle()
                    .fill(Material.thin)//
                symbol()
                    .imageScale(.medium)
                    .bold()//
            }  .frame(width: 36, height: 36, alignment: .center)
            
            
        } else {
            return ZStack {
                Circle()
                    .fill(Color.black.opacity(0.8))//
                symbol()
                    .imageScale(.medium)
                //                    .bold()//
            }  .frame(width: 36, height: 36, alignment: .center)
            
        }
        
        
        
    }
}


//@available(watchOS 10.0, *)
struct TopControlView: View {
    //    @available(watchOS 10.0, *)
    func 制作按钮<V:View>(symbol:V,action:@escaping ()->()) -> some View {
        if #available(watchOS 10.0, *) {
            return ZStack {
                Circle()
                    .fill(Material.thin)//
                symbol
                    .imageScale(.medium)
                    .bold()//
            }  .frame(width: 36, height: 36, alignment: .center)
                .beButton {
                    action()
                }
                .buttonStyle(.plain)
            
        } else {
            return ZStack {
                Circle()
                    .fill(Color.black.opacity(0.8))//
                symbol
                    .imageScale(.medium)
                //                    .bold()//
            }  .frame(width: 36, height: 36, alignment: .center)
                .beButton {
                    action()
                }
                .buttonStyle(.plain)
            
        }
        
        
        
    }
    var backButtonTap:()->()
    var sideBarTap:()->()
    
    
    var body: some View {
        if true {//#available(watchOS 10, *)
            HStack {
                制作按钮(symbol:     Image(systemName: "xmark"), action: backButtonTap)
                    .padding(.leading,12.5)
                    .padding(.top,15)
                    .ignoresSafeArea(.container, edges: [.leading,.top])
                Spacer()
                制作按钮(symbol:    Image(systemName: "chevron.right"), action: sideBarTap)
                    .padding(.trailing,12.5)
                    .padding(.top,15)
                    .ignoresSafeArea(.container, edges: [.trailing,.top])
            }
        } else {
            HStack {
                Color.touchZone
                    .resizable()
                    .frame(width: 38, height: 38, alignment: .center)
                    .overlay(content: {
                        Circle()
                            .os10Material()
                    })
                    .overlay(content: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    })
                    .beButton(backButtonTap)
                    .buttonStyle(.plain)
                    .shadow(color: .black, radius: 7, x: 3, y: 3)
                Spacer()
                Color.touchZone
                    .resizable()
                    .frame(width: 38, height: 38, alignment: .center)
                    .overlay(content: {
                        Circle()
                            .os10Material()
                        
                    })
                    .overlay(content: {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    })
                    .beButton(sideBarTap)
                    .buttonStyle(.plain)
                    .shadow(color: .black, radius: 7, x: 3, y: 3)
            }
            .scenePadding()
        }
    }
}
extension View where Self:Shape {
    @ViewBuilder
    func os10MaterialGray() -> some View {
        if #available(watchOS 10, *) {
            self
                .fill(Material.ultraThin)
        } else {
            self
                .fill(Color.gray.opacity(0.67))
        }
    }
}

extension View where Self:Shape {
    @ViewBuilder
    func os10Fill() -> some View {
        if #available(watchOS 10, *) {
            self
                .stroke(Color.white, style: StrokeStyle(lineWidth: 6.7, lineCap: .round, lineJoin: .round))
        } else {
            self  .
            stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        }
    }
}
extension View where Self:Shape {
    @ViewBuilder
    func os10Material() -> some View {
        if #available(watchOS 10, *) {
            if visualEffectDisable {
                self
                    .fill(Color.black.opacity(0.8))
                
            } else {
                self
                    .fill(Material.ultraThin)
                
            }
        } else {
            self
                .fill(Color.black.opacity(0.8))
        }
    }
}
var visualEffectDisable = false
struct OverlayLS<V:View>: View {
    @Binding var loopingPlayback:Bool
    var avplayer:AVPlayer
    @Binding var videoRatio:全屏按钮设定
    var listItems:()->(V)
    @Binding var showMenu:Bool
    @SceneStorage("screenBound")
    var screenBound = WKInterfaceDevice.current().screenBounds
    @State var 启动 = false
    @State var opt = 1.0
    @State var gestureH:Double = 44
    @AppStorage("播放器画布")
    var playerSize:播放器画布 = .正常
    @State var musicTapped = false
    @State var showMenu1 = false
    var body: some View {
        ScrollView(.horizontal, content: {
            ZStack {
                Rectangle()
                    .os10Material()
                    .frame(width: screenBound.width, height: screenBound.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .readPosition(in: .named("播放器"), onChange: { rect in
                        if rect.minX <= 10 {
                            启动 = true
                        }
                        if 启动 {
                            if rect.minX > gestureH {
                                dismissMe()
                            }
                        }
                    })
                ScrollViewReader { proxy in
                    if #available(watchOS 9, *) {
                        myMenu(proxy:proxy)
                    } else {
                        VStack {
                            if showMenu1.not {
                                Button("加载菜单（可能会闪退）", action: {
                                    showMenu1.toggle()
                                })
                            } else {
                                myMenu(proxy:proxy)
                            }
                        }
                    }
                }
            }
        })
        .opacity(opt)
        .onLoad {
            let h:Double = {
                let num:Double = 6
                printLog(screenBound.width/num)
                if screenBound.width/num > 33 {
                    return 33
                } else {
                    return screenBound.width/num
                }
            }()
            gestureH = h
            DispatchAfter(after: 0.2, handler: {
                withAnimation(.easeOut(duration: 0.2)) {
                    myProxy?.scrollTo(下次滚动位置,anchor: .center)
                }
            })
        }
        .opacity(visiulHideMenu ? 0 : 1)
    }
    @StateObject var doubleTaoMod = BilliVideoPlayerSummerDoubleTapModel()
    @ViewBuilder
    func myMenu(proxy:ScrollViewProxy) -> some View {
        List {
            Text("").font(.footnote)
            
            Button(action: {
                exitPlayerbuttonTapped.send()
            }) {
                Label("退出播放", systemImage: "pip.exit")
            }
            .autoScroll(id: "5dd33b8e")
             
            Label(musicTapped ? "右滑关闭菜单，然后旋转手表侧边旋钮调节音量" : "调节音量", systemImage: "speaker.wave.2.fill")
                .beButton {
                    withAnimation(.smooth) {
                        musicTapped.toggle()
                    }
                }
                .autoScroll(id: "7f3edfdd")
            Section("播放尺寸", content: {
                HStack {
                    Spacer()
                    Button(action: {
                        playerSize = .正常
                    }) {
                        Label("正常", systemImage: "arrow.down.right.and.arrow.up.left")
                            .minimumScaleFactor(0.1)
                            .scaledToFit()
                    } .minimumScaleFactor(0.1)
                        .scaledToFit()
                    Spacer()
                    Button(action: {
                        playerSize = .全屏
                    }) {
                        Label("全屏", systemImage: "arrow.up.left.and.arrow.down.right") .minimumScaleFactor(0.1)
                            .scaledToFit()
                    } .minimumScaleFactor(0.1)
                        .scaledToFit()
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            })
            
            .autoScroll(id: "1d5fb61a")
            
            if #available(watchOS 10, *) {
                Section("倍速", content: {
                    Universal的倍速开关()
                        .autoScroll(id: "1k5fb31b")
                })
            }
            Toggle("单集循环播放", isOn: $loopingPlayback)
            listItems()
            双击操作Picker()
                .autoScroll(id: "716eg3f5")
            Section("精细调整进度", content: {
                HStack {
                    Button(action: {
                        跳跃(加: true)
                    }, label: {
                        Label("加5秒", systemImage: "plus")
                            .minimumScaleFactor(0.1)
                            .scaledToFit()
                    }) .minimumScaleFactor(0.1)
                        .scaledToFit()
                    Button(action: {
                        跳跃(加: false)
                    }, label: {
                        Label("减5秒", systemImage: "minus") .minimumScaleFactor(0.1)
                            .scaledToFit()
                    }) .minimumScaleFactor(0.1)
                        .scaledToFit()
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            })    .minimumScaleFactor(0.1)
                .scaledToFit()
                .autoScroll(id: "716ea3f3")
        
        }
        .onLoad {
            self.myProxy = proxy
        }
    }
    
    @State var myProxy:ScrollViewProxy?
    func 跳跃(加:Bool) {
        let currentTime = avplayer.currentTime().seconds
        if currentTime.isNaN.not {
            if 加 {
                avplayer.currentItem?.seek(to: CMTimeMakeWithSeconds(currentTime+5, preferredTimescale: 1))
            } else {
                avplayer.currentItem?.seek(to: CMTimeMakeWithSeconds(currentTime-5, preferredTimescale: 1))
            }
        }
    }
    func dismissMe() {
        if showMenu {
            let 下次滚动到 = closestRect(rects: all侧边栏Views, toPoint: screenBound.center)
            下次滚动位置 = 下次滚动到
            withAnimation(.smooth) {
                opt = 0
                DispatchAfter(after: 0.3, handler: {
                    showMenu = false
                })
                
            }
        }
    }
    func closestRect(rects: [String : CGRect], toPoint givenPoint: CGPoint) -> String? {
        var closestRect: String?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for rectR in rects {
            let rect = rectR.value
            // 计算CGRect的中心点
            let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
            // 计算距离
            let dx = centerPoint.x - givenPoint.x
            let dy = centerPoint.y - givenPoint.y
            let distance = sqrt(dx*dx + dy*dy)
            // 更新距离最小的CGRect
            if distance < minDistance {
                minDistance = distance
                closestRect = rectR.key
            }
        }
        
        return closestRect
    }
}
var 下次滚动位置:String?
var all侧边栏Views:[String:CGRect] = [:]
extension View {
    @ViewBuilder
    func autoScroll(id:String) -> some View {
        self
        
            .readPosition(in: .named("侧边栏"), onChange: { rect in
                all侧边栏Views[id] = rect
            })
            .id(id)
    }
}
typealias PinnedRecipes2 = CGRect
extension PinnedRecipes2: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(PinnedRecipes2.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

typealias PinnedRecipes1 = 播放器画布
extension PinnedRecipes1: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(PinnedRecipes1.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
//
//  暂停模式设定.swift
//  Sustainably Watch App
//
//  Created by 凌嘉徽 on 2023/8/12.
//

import SwiftUI

struct PauseModPage: View {
    @AppStorage("biliPauseMod") var biliPauseMod = 2
    var body: some View {
        DoublePicker(selectionMode: $biliPauseMod, pickerInlineTitle: "视频自动暂停模式", pickerInlineSFSymbol: "playpause.fill", item1Name: "屏幕熄灭即暂停（适用于上课摸鱼）", item2Name: "屏幕熄灭继续播放（适用于运动）",tip:"如果您希望避免“翻手腕屏幕即熄灭”，可以在手表“系统设置>显示与亮度>唤醒时长”中设置70秒。")//🐃
    }
}

struct 双击操作Picker: View {
    @AppStorage("BiliPlayerDoubleTapAction") var BiliPlayerDoubleTapAction:BilliVideoPlayerSummerDoubleTapModel.双击操作 = .禁用
    @State var biliPauseMod = 1
    var body: some View {
        DoublePicker(selectionMode: $biliPauseMod, pickerInlineTitle: "双击视频操作", pickerInlineSFSymbol: "hand.point.up.braille.fill", item1Name: "无", item2Name: "放大缩小",item3Name: "暂停继续")
            .onChange(of: biliPauseMod, perform: { i in
                if let r = BilliVideoPlayerSummerDoubleTapModel.双击操作.init(rawValue: i-1) {
                    self.BiliPlayerDoubleTapAction = r
                }
            })
    }
}



class BilliVideoPlayerSummerDoubleTapModel:ObservableObject {
    @AppStorage("BiliPlayerDoubleTapAction") var BiliPlayerDoubleTapAction:双击操作 = .禁用
    enum 双击操作:Int,Identifiable,CaseIterable {
        var id: Int { self.rawValue }
        case 禁用 = 0
        case 放大缩小 = 1
        case 暂停继续 = 2
        var name:String {
            switch self {
            case .禁用:
                return "禁用"
            case .放大缩小:
                
                return "放大缩小"
            case .暂停继续:
                return "暂停继续"
            }
        }
    }
}
