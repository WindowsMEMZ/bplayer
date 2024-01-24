//
//  FlyComment.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI
import AVKit
import AVFoundation

@available(watchOS 10.0, *)
struct 仅添加弹幕: View {
    @State var player:AVPlayer?
    @Binding var videoCid:Int64
    @State var playing = false
    @State var currentTime = 0.0
    @State var info:VideoInfoDanMu?
    @State var timer = Timer.publish(every: 0.1,tolerance: 0.1, on: .main, in: .default).autoconnect()
    @State var token:NSKeyValueObservation?
    @AppStorage("showBiliDanmu") var showBiliDanmu = true
    @AppStorage("biliPlayerAskShowDM") var biliPlayerAskShowDM = true
    
    var body: some View {
        ZStack {
            DanMuOverlayMain(isVideoPlaying: $playing, currentTime: $currentTime, isDragProgess: .constant(false),videoInfo: $info)
                .allowsHitTesting(false)
                .opacity(showBiliDanmu ? 1 : 0)
                .opacity(biliPlayerAskShowDM ? 1 : 0)
            //            }
        }
        .animation(.smooth, value: biliPlayerAskShowDM)
        .onReceive(timer, perform: { _ in
            //需要给弹幕组件也更新当前的播放时间和暂停状态
            playing = (player?.timeControlStatus == .playing)//对播放严格
            if let time = player?.currentTime().seconds {
                self.currentTime = time
            } else {
                
            }
            //反复获取，直到获取到了
            if 获取到了 == false {
                if let total = player?.currentItem?.duration.seconds {
                    if total.isNaN {
                        
                    } else {
                        获取到了 = true
                        printLog("DM-发送加载信号")
                        startLoadingDM.send(.init(videoCid:String(videoCid), videoTotalTime: total))
                    }
                }
            }
        })
    }
    @State var 获取到了 = false
}
//
//  弹幕.swift
//  WatchBili Watch App
//
//  Created by 凌嘉徽 on 2023/9/18.
//

import Foundation
//
//  ContentView.swift
//  DanMu Watch App
//
//  Created by 凌嘉徽 on 2023/8/20.
//

import SwiftUI
//let 时间间隔 = 0.1
import Combine
@available(watchOS 10.0, *)
let delDamMu = PassthroughSubject<OnlineDanMu,Never>()
let videoPause = PassthroughSubject<Void,Never>()
let videoContinue = PassthroughSubject<Void,Never>()
let videoJump = PassthroughSubject<Double,Never>()
let screenMax = WKInterfaceDevice.current().screenBounds.height
@available(watchOS 10.0, *)
struct 每条弹幕: View {
    @SceneStorage("screenBound") var screenBound = WKInterfaceDevice.current().screenBounds
    var screenWidth:Double { screenBound.width }
    @StateObject var item:OnlineDanMu
    @State var myOffSet = screenMax
    var allTime:Double
    @Binding var currentVideoTime:Double
    @State var startDate = Date()
    @State var cancellableTask = CancellableTask()
    var body: some View {
//        HStack {
        Text(" ")//撑起高度
            .frame(width: screenWidth, alignment: .leading)
            .overlay(content: {
                ZStack {
                    Color.clear
                    HStack(spacing:0) {
                        Text(item.content).shadow(color: .black, radius: 1)
                            .readSize(onChange: { size in
                                MainActor {
                                    item.myWidth = size.width
                                    if let myWidth = item.myWidth {
                                        let 剩余所需时间 = myWidth/计算速度()
                                        let animationTime = allTime + 剩余所需时间
                                        printLog("弹幕\(item.content)\(animationTime)")
                                        withAnimation(.linear(duration: animationTime)) {
                                            myOffSet = -myWidth
                                        }
                                        startDate = .now
                                        // 使用示例
                                        
                                        
                                        // 执行延迟操作
                                        cancellableTask.performDelayedOperation(after: animationTime) {
                                            printLog("删除\(item.content)")
                                            delDamMu.send(item)
                                        }
                                        
                                        // 如果需要取消操作
                                     
                                    } else {
                                        printLog("报错!")
                                    }
                                }
                            })
                            .onReceive(videoPause, perform: { _ in
                                printLog("暂停\(item.content)")
                           
                                    //计算运动了多少时间（以此推断位移百分比）
                                        let currentDate = Date()
                                        let timeInterval = currentDate.timeIntervalSince(startDate)
                                        我已经运动了多久 += timeInterval
//                                        printLog("过去了",我已经运动了多久)
                                    计算新位置()
                                
                            })
                            .onReceive(videoContinue, perform: { _ in
                                printLog("继续\(item.content)")
                                guard let myWidth = item.myWidth,let animationTime = 剩余所需时间A else { return }
                                startDate = .now
                                withAnimation(.linear(duration: animationTime)) {
                                    myOffSet = -myWidth
                                }
                                // 执行延迟操作
                                cancellableTask.performDelayedOperation(after: animationTime) {
                                    delDamMu.send(item)
                                }
                            })
                            .onReceive(videoJump, perform: { i in
                                printLog("跳转\(item.content)")
                                let currentDate = Date()
                                let timeInterval = currentDate.timeIntervalSince(startDate)
                                我已经运动了多久 += timeInterval
//                                printLog("过去了",我已经运动了多久)
                                我已经运动了多久 += i
                                计算新位置(jump: true)
                                videoContinue.send()
                            })
                        Spacer()
                    }
                }.frame(width: 444)
                    .offset(x: 444/2-screenWidth/2)
            })
      
//        }
            .offset(x: myOffSet, y: 0)
            .transition(.asymmetric(insertion: .scale(scale: 0.1, anchor: .trailing).combined(with: .opacity), removal: .scale(scale: 0.1, anchor: .leading).combined(with: .opacity)).animation(.smooth))
            .onLoad {
                self.myOffSet = screenBound.width
            }
    }
    @State var 我已经运动了多久 = 0.0
    @State var 剩余所需时间D:Double?
    @State var 剩余所需时间A:TimeInterval?
    func 计算新位置(jump:Bool = false) {
        //计算运动了多少时间（以此推断位移百分比）
            guard let myWidth = item.myWidth else { return }
            let animationTime = 计算总时间(myWidth:myWidth)
//            printLog("总",animationTime)
            let 还需要time = animationTime - 我已经运动了多久
            self.剩余所需时间A = 还需要time
            self.剩余所需时间D = currentVideoTime
//            printLog("还需要time",还需要time)
            if 还需要time > 0 {
                //只有快退会这样！
                if 还需要time > animationTime {
                    delDamMu.send(item)
                }
                let 总量 = screenWidth + myWidth
                let 百分比 = 还需要time/animationTime
                let 已过去 = 1-百分比
//                printLog("完成度",已过去)
                let 已过去位移 = 总量 * 已过去
                let 开始计算 = screenWidth - 已过去位移
//                printLog("当前", 开始计算)
                withAnimation(jump ? .easeOut : .smooth) {
                    myOffSet = 开始计算 - 20
                }
//                printLog("暂停成功！")
                cancellableTask.cancel()
//                                    let 计算位移 =
            } else {
                delDamMu.send(item)
            }
    }
    func 计算速度() -> Double {//像素/秒
        let screenWidth = screenBound.width
        let speed = screenWidth/allTime
//        printLog(speed)
        return speed
    }
    func 计算总时间(myWidth:Double) -> TimeInterval {
       
        let 剩余所需时间 = myWidth/计算速度()
        let animationTime = allTime + 剩余所需时间
        return animationTime
    }
}


@available(watchOS 10.0, *)
struct VideoInfoDanMu:Identifiable,Equatable {
    var id = UUID()
    var videoCid:String
    var videoTotalTime:TimeInterval
}
@available(watchOS 10.0, *)
let startLoadingDM = PassthroughSubject<VideoInfoDanMu,Never>()

let initDM = PassthroughSubject<Void,Never>()
let 精度 = 0.1
@available(watchOS 10.0, *)
struct DanMuOverlayMain: View {
    @Binding var isVideoPlaying:Bool
    @Binding var currentTime:Double
    @Binding var isDragProgess:Bool
    @Binding var videoInfo:VideoInfoDanMu?
    @State var timer = Timer.publish(every: 精度, on: .main, in: .default).autoconnect()
    @StateObject var mod = 弹幕发送Mod()
    @State var 启用 = false
    @State var videoTotalTime:Double = 0//秒
    @AppStorage("biliPlayerLandscape") var biliPlayerLandscape = false
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if false {
                        ScrollView {
                            VStack {
                                Spacer()
                                Text("\(mod.currentTime)")
                                Text("\(mod.销毁条数)")
                            }
                        }
                    }
                }
                VStack {
                    ZStack {
                        //尺寸限位
                        每条弹幕(item: .init(content: " ", startTime: Double(Int.max)), allTime: Double(Int.max), currentVideoTime: $mod.currentTime)
                        ForEach(mod.slot1, content: { each in
                            每条弹幕(item: each, allTime: mod.traveAllTime,currentVideoTime: $mod.currentTime)
                        })
                    }
                    ZStack {
                        //尺寸限位
                        每条弹幕(item: .init(content: " ", startTime: Double(Int.max)), allTime: Double(Int.max),currentVideoTime: $mod.currentTime)
                        ForEach(mod.slot2, content: { each in
                            每条弹幕(item: each, allTime: mod.traveAllTime,currentVideoTime: $mod.currentTime)
                        })
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
        .onChange(of: isVideoPlaying, perform: { i in
            启用 = isVideoPlaying
            if isVideoPlaying {
                self.play()
            } else {
                self.pause()
            }
        })
       
        .onReceive(timer, perform: { _ in
            if 启用 || isDragProgess {
                mod.触发每次Tick()
                mod.currentTime = currentTime
            }
        })
        //0.5秒自动检查加载新的弹幕包
        .onReceive(loadNewPackTimer, perform: { _ in
            if 计算完成 {
                mod.loadNewPack()
            }
        })
        .onReceive(startLoadingDM, perform: { obj in
            let videoInfo = obj
            开始加载弹幕(videoCid: videoInfo.videoCid, videoTotalTime: videoInfo.videoTotalTime)
        })
        .onChange(of: isDragProgess, perform: { value in
            if value {
                startValue = currentTime
                videoPause.send()
            } else {
                printLog("变了\(currentTime - startValue)")
                videoContinue.send()
                videoJump.send(currentTime - startValue)
            }
        })
    }
    @State var startValue = 0.0
    var count = 0
    func 开始加载弹幕(videoCid:String,videoTotalTime:TimeInterval) {
        mod.videoCid = videoCid
        self.videoTotalTime = videoTotalTime
        启用 = true
        print("正在加载弹幕")
        Task {
            do {
                let totalSeconds = videoTotalTime
                let intervalCount = mod.countRoundedSixMinuteIntervals(from: totalSeconds)
                print("Total rounded 6-minute intervals: \(intervalCount)")
                mod.所有 = Array(repeating: false, count: intervalCount)
                mod.所有分包 = Array(repeating: [], count: intervalCount)
                计算完成 = true
            } catch {
                printLog(error)
            }
        }
    }
    func play() {
        启用 = true
        videoContinue.send()
    }
    func pause() {
        启用 = false
        videoPause.send()
    }
    func timeChange(newTime:TimeInterval) {
        mod.currentTime = newTime
        interpolator.changeSoftly(to: newTime, over: 0.3)
    }
    let valueJumpTimer = Timer.publish(every: 0.3, tolerance: 0.3, on: .main, in: .default).autoconnect()
    
    @State var 计算完成 = false
    let loadNewPackTimer = Timer.publish(every: 0.5, tolerance: 0.5, on: .main, in: .default).autoconnect()
    
    let interpolator = DanMuInterpolator()

   
    
}

import Foundation
@available(watchOS 10.0, *)
class DanMuInterpolator {
    
    private var currentSoftValue: Double
    private var targetValue: Double
    private var increment: Double = 0.0
    private var timer: Timer?
     
//    let videoJump = PassthroughSubject<Double, Never>()

    init(startingValue: Double = 0) {
        self.currentSoftValue = startingValue
        self.targetValue = startingValue
    }

    func changeImmediately(to newValue: Double) {
        self.currentSoftValue = newValue
        self.targetValue = newValue
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func changeSoftly(to newValue: Double, over duration: TimeInterval) {
        self.targetValue = newValue
        self.increment = (newValue - currentSoftValue) / (duration / 0.1)  // Change every 0.01 second
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if abs(self.currentSoftValue - self.targetValue) < abs(self.increment) {
                videoJump.send(self.targetValue - self.currentSoftValue)
                self.currentSoftValue = self.targetValue
                timer.invalidate()
                self.timer = nil
            } else {
                videoJump.send(self.increment)
                self.currentSoftValue += self.increment
            }
        }
    }
}
@available(watchOS 10.0, *)
struct 弹幕DebugView: View {
    @StateObject var mod = 弹幕发送Mod()
    let timer = Timer.publish(every: 精度, on: .main, in: .default).autoconnect()
    @State var 启用 = false
    let videoTotalTime:Double = 360*6//秒
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if true {
                        ScrollView {
                            VStack {
                                Spacer()
                                Text("\(mod.currentTime)")
                                Button("开始", action: {
                                    启用 = true
                                    Task {
                                        do {
                                            let totalSeconds = videoTotalTime
                                            let intervalCount = mod.countRoundedSixMinuteIntervals(from: totalSeconds)
                                            print("Total rounded 6-minute intervals: \(intervalCount)")
                                            mod.所有 = Array(repeating: false, count: intervalCount)
                                            mod.所有分包 = Array(repeating: [], count: intervalCount)
                                            计算完成 = true
    //                                        try await mod.下载第一P()
                                        } catch {
                                            printLog(error)
                                        }
                                    }
                                })
                                Button("继续", action: {
                                    启用 = true
                                    videoContinue.send()
                                })
                                Button("暂停", action: {
                                    启用 = false
                                    videoPause.send()
                                })
                                Button("快进5", action: {
                                    mod.currentTime += 5
                                    videoJump.send(5)
                                })
                                Button("快进5", action: {
                                    mod.currentTime += 0.5
                                    videoJump.send(0.5)
                                })
                                Text("\(mod.销毁条数)")
                            }
                        }
                    }
                }
                VStack {
                    ZStack {
                        //尺寸限位
                        每条弹幕(item: .init(content: " ", startTime: Double(Int.max)), allTime: Double(Int.max), currentVideoTime: $mod.currentTime)
                        ForEach(mod.slot1, content: { each in
                            每条弹幕(item: each, allTime: mod.traveAllTime,currentVideoTime: $mod.currentTime)
                        })
                    }
                    ZStack {
                        //尺寸限位
                        每条弹幕(item: .init(content: " ", startTime: Double(Int.max)), allTime: Double(Int.max),currentVideoTime: $mod.currentTime)
                        ForEach(mod.slot2, content: { each in
                            每条弹幕(item: each, allTime: mod.traveAllTime,currentVideoTime: $mod.currentTime)
                        })
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
        .onReceive(timer, perform: { _ in
            if 启用 {
                mod.触发每次Tick()
                mod.currentTime += 精度
            }
        })
        .onReceive(loadNewPackTimer, perform: { _ in
            if 计算完成 {
                mod.loadNewPack()
            }
        })
    }
    @State var 计算完成 = false
    let loadNewPackTimer = Timer.publish(every: 0.5, tolerance: 0.5, on: .main, in: .default).autoconnect()
}
@available(watchOS 10.0, *)
//@Observable
class OnlineDanMu:ObservableObject,Identifiable {
    @Published
    var id = UUID()
    @Published
    var content:String
    @Published
    var startTime:Double
    @Published
    var myWidth:Double?
    init(content: String, startTime: Double) {
        self.content = content
        self.startTime = startTime
    }
}
@available(watchOS 10.0, *)

class 弹幕发送Mod:ObservableObject {
    @Published var videoCid = ""
    @Published var slot1:[OnlineDanMu] = []
    @Published var slot2:[OnlineDanMu] = []
    @Published var currentTime = 0.0
    @SceneStorage("screenBound")
    var screenBound = WKInterfaceDevice.current().screenBounds
    var screenWidth:Double {
        screenBound.width
    }
    let traveAllTime = 3.0//秒
    @Published var token:AnyCancellable!
    @Published var 视频下载模式 = false
    func countRoundedSixMinuteIntervals(from seconds: Double) -> Int {
        let sixMinuteIntervalInSeconds = 360.0
        let intervalCount = ceil(seconds / sixMinuteIntervalInSeconds)
        return Int(intervalCount)
    }
    @Published var 所有:[Bool] = []
    @Published var 所有分包:[[弹幕发送Mod.ADanMu]] = []
    init() {
        token = delDamMu.sink(receiveValue: { [self] dan in
            if let slot1index = slot1.firstIndex(where: {
                $0.id == dan.id
            }) {
                printLog("销毁\(slot1[slot1index].content)")
                withAnimation(.easeOut) {
                    slot1.remove(at: slot1index)
                }
               
                销毁条数 += 1
            }
            if let slot2index = slot2.firstIndex(where: {
                $0.id == dan.id
            }) {
                printLog("销毁\(slot2[slot2index].content)")
                withAnimation(.easeOut) {
                    slot2.remove(at: slot2index)
                }
               
                销毁条数 += 1
            }
        })
    }
    class ADanMu:Identifiable {
        var id = UUID()
        var content:String
        var time:Double
        var 已发送 = false
        init(id: UUID = UUID(), content: String, time: Double) {
            self.id = id
            self.content = content
            self.time = time
        }
    }
    @Published var danmus:[ADanMu] = [
//        .init(content: "弹幕一", time: 0),
//        .init(content: "弹幕二今天天气怎么样", time: 3),  .init(content: "弹幕三你感觉如何", time: 5),  .init(content: "弹幕四苹果真nb", time: 8),  .init(content: "弹幕五明天开学123跳", time: 11),  .init(content: "弹幕六你是最大的宝贝", time: 16)
    ]
    func 计算我的等效位移(startTime:Double) -> Double {
        let 经过时间 = currentTime - startTime
        if 经过时间 >= traveAllTime {
            return screenWidth
        } else {
            let 进度 = 经过时间/traveAllTime
         return screenWidth * 进度
        }
    }
    func 触发每次Tick() {
        let res = 检查是否有()
        if res.isEmpty {
            return
        } else {
            res.forEach { i in
            发射(item: i)
            }
        }
    }
    let 最大跳过时间次数 = 5.0//5.0*精度=0.5秒
    @Published var 跳过次数 = 0
    func 检查是否有() -> [ADanMu] {
       
        let start = currentTime
        let end = currentTime + 精度
        let end宽松 = currentTime + 最大跳过时间次数*精度//时间窗口：延后0.5秒内的也有机会触发
        var res严格:[ADanMu] = []
        var res宽松:[ADanMu] = []
        danmus.filter {
            $0.已发送 == false
        }.forEach { i in
            if (start <= i.time) && (i.time < end) {
                res严格.append(i)
            }
        }
       
        danmus.filter {
            $0.已发送 == false
        }.forEach { i in
            if (start <= i.time) && (i.time < end宽松) {
                res宽松.append(i)
            }
        }
        if 跳过次数 >= Int(最大跳过时间次数) {
            跳过次数 = 0
            return res严格
        } else {
            if res宽松.count > res严格.count {
                //printLog("需要操作")
                跳过次数 += 1
                return []
            } else {
                跳过次数 = 0
                return res严格
            }
        }
    }
    func 计算右侧空白(item:OnlineDanMu) -> Double {
        let 已经经过 = 计算我的等效位移(startTime: item.startTime)
        if let width = item.myWidth {
            let 右侧 = 已经经过 - width
            return 右侧
        } else {//还没来得及上屏，所以测不出来
            return Double(-Int.max)
        }
    }
    //nil即都不可用
    func 选择最小slot() -> Int? {
        if let slot1有 = slot1.last {
            if let slot2有 = slot2.last {
                let slot1右侧 = 计算右侧空白(item: slot1有)
                let slot2右侧 = 计算右侧空白(item: slot2有)
                if slot1右侧 < 0 && slot2右侧 < 0 {
                    return nil
                }
                if slot1右侧 > slot2右侧 {
                    return 1
                } else {
                    return 2
                }
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    @Published var 销毁条数 = 0
    func 发射(item:ADanMu) {
        switch 选择最小slot() {
        case 1:
            slot1.append(.init(content: item.content, startTime: currentTime))
            item.已发送 = true
        case 2:
            slot2.append(.init(content: item.content, startTime: currentTime))
            item.已发送 = true
        default:
            print("丢弃\(item.content)")
            break
        }
    }
    func 下载第一P() async throws {
        try await 开始下载(一开始: 1)
    }
   
    @Published var 当前使用:Int?//一开始
    // MARK: - 下载
    func 开始下载(一开始 分包:Int) async throws {
        
        if 当前使用 == 分包 {
            return
        }
        let index = 分包-1
        if self.所有.safe(index) == true {
            await MainActor.run {
                self.danmus = self.所有分包[index]
            }
            return
        }
        let url = "https://api.bilibili.com/x/v2/dm/list/seg.so?type=1&oid=\(videoCid)&segment_index=\(分包)"
//        let url = Bundle.main.url(forResource: "seg-4", withExtension: "so")!
        printLog("触发下载第\(分包)分包")
        if 正在下载who == 分包 {
            return
        }
        //同步到“弹幕缓存”
        正在下载who = 分包
        if 分包 >= 5 {
            printLog("等待5秒")
             try await Task.sleep(nanoseconds: 5*1_000_000_000)
        }
        if let 现有 = try? await downloadMod.获取Obj(cid: Int64(videoCid) ?? 0).dmPacks.last { i in//最后一个是最新的
            i.myPackIndex == index
        },let dmData = 现有.dmData {
            下载完成的弹幕(index:index,分包: 分包, data: dmData)
        } else {
            fetchData(from: url, completion: { [self] data,err in
                Task {
                    if let data {
                        printLog("弹幕下载成功")
                        下载完成的弹幕(index:index,分包: 分包, data: data)
                        if 视频下载模式 {
                            if let cid64 = Int64(videoCid) {
                                try? await 缓存下载完成的内容(cid: cid64, packIndex: index, data: data)
                            }
                        }
                    } else {
                        if 视频下载模式 {
                            showToast.send("下载弹幕出错，请添加合适的提示")
                        } else {
                            printLog("下载弹幕出错")
                        }
                    }
                }
            })
        }
    }
    @Published var mod = 弹幕视频下载Mod()
    func 缓存本视频的弹幕(cid:Int64,videoTotalTime:Double) {
        Task {
            if let my = try? await mod.获取Obj(cid: cid) {
                var new = my
                new.dmPacks = []
                mod.添加一个Obj(cid: cid, obj: new)
            }
            视频下载模式 = true
            let intervalCount = countRoundedSixMinuteIntervals(from: videoTotalTime)
            print("收到下载弹幕请求:Total rounded 6-minute intervals: \(intervalCount)")
            videoCid = "\(cid)"
            所有 = Array(repeating: false, count: intervalCount)
            所有分包 = Array(repeating: [], count: intervalCount)
            for i in 1...intervalCount {
//                Task {
                    printLog("收到下载弹幕请求:\(i)")
                    try await 开始下载(一开始:i)
//                }
            }
        }
    }
    func 缓存下载完成的内容(cid:Int64,packIndex:Int,data:Data) async throws {
        if let 现有 = try? await downloadMod.获取Obj(cid: Int64(videoCid) ?? 0) {
            var new = 现有
            new.dmPacks.append(.init(myPackIndex: packIndex, dmData: data))
            downloadMod.添加一个Obj(cid: cid, obj: new)
        } else {
            downloadMod.添加一个Obj(cid: cid, obj: .init(belongCID: cid,allPacksCount:所有.count, dmPacks: [
                .init(myPackIndex: packIndex, dmData: data)
            ]))
        }
    }
    let downloadMod = 弹幕视频下载Mod()
    func 下载完成的弹幕(index:Int,分包:Int,data:Data) {
        @AppStorage("DMLoaded") var 弹幕挂载完成 = false
        DispatchQueue.global(qos: .background).async {
                do {
                //bilibili.community.service.dm.v1.dm_pb2
                //DmSegMobileReplyhttps://api.bilibili.com/x/v2/dm/list/seg.so?type=1&oid=1243915960&segment_index=1
                let res = try Bilibili_Community_Service_Dm_V1_DmSegMobileReply(serializedData: data)
                //                printLog(res.elems.first)
                let allDM = res.elems.map { e in
                    let time:Double = Double(e.progress)/1000
                    let content = e.content
                    return 弹幕发送Mod.ADanMu.init(content: content, time: time)
                }
                MainActor {
                    self.当前使用 = 分包
                    if let _ = self.所有分包.safe(index) {
                        self.所有分包[index] = allDM
                    }
                    self.danmus = allDM
                    if let _ =  self.所有.safe(index) {
                        self.所有[index] = true
                    }
                    printLog("弹幕加载成功")
                    弹幕挂载完成 = true
                }
            } catch {
                printLog(error.localizedDescription)
                
            }
        
        }
    }
    @Published var 正在下载who:Int?
    func loadNewPack() {
        let current包 = getCurrentInterval(currentTime: currentTime+1)
        Task {
            try await 开始下载(一开始:Int(current包))
        }
    }
    func getCurrentInterval(currentTime: Double) -> Int {
        let sixMinuteIntervalInSeconds = 360.0
        let currentPkg = ceil(currentTime / sixMinuteIntervalInSeconds)
        return Int(currentPkg)
    }
}
class HeaderGenerator {
    static var shared = HeaderGenerator()
    private init() {
    }
    @AppStorage("SESSDATA") var SESSDATA = ""
    @AppStorage("bili_jct") var bili_jct = ""
    @AppStorage("DedeUserID") var DedeUserID = ""
    func darockHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "cookie": "SESSDATA=\(SESSDATA)",
            "User-Agent": "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        ]
        return headers
    }
  
    func basicHeader() -> HTTPHeaders {
        let ramdomReferer = ["https://www.bilibili.com/video/\(UUID())/","https://search.bilibili.com/all?keyword=\(UUID())"]
        let headers: HTTPHeaders = [
            "Authority": "passport.bilibili.com",
            "Method": "GET",
            "Scheme": "https",
            "Accept":"application/json, text/plain, */*",
            "Accept-Encoding": "gzip, deflate, br",
            "Origin":"https://search.bilibili.com",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
            "Referer":ramdomReferer.randomElement()!,
            "Sec-Ch-Ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0",
            "Sec-Ch-Ua-Mobile": "?0",
            "Sec-Ch-Ua-Platform": "\"macOS\"",
            "Sec-Fetch-Dest": "script",
            "Sec-Fetch-Mode": "no-cors",
            "Sec-Fetch-Site": "cross-site",
            "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0",
            "Cookie": "SESSDATA=\(SESSDATA); bili_jct=\(bili_jct); DedeUserID=\(DedeUserID);"]
        return headers
    }

}
func fetchData(from url: String, completion: @escaping (Data?, Error?) -> Void) {
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }
    guard let headers = try? HeaderGenerator.shared.darockHeader() else {
        completion(nil, 错误.消息(message: "未登录，不能生成请求头"))
        return
    }
    guard let urlRequest = try? URLRequest(url: url, method: .get, headers: headers) else {
        completion(nil, 错误.消息(message: "无法正常生成URLRequest"))
        return
    }
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data else {
            completion(nil, error)
            return
        }
        completion(data, nil)
    }
    task.resume()
}

func downloadData(from urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL!")
        return
    }

    let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
        if let error = error {
            print("Download failed with error: \(error.localizedDescription)")

            completion(nil, response, error)
        } else {
            guard let localURL = localURL else {
                print("Failed to get local URL!")
                return
            }
        
            do {
                let data = try Data(contentsOf: localURL)
                
                completion(data, response, error)
            } catch {
                print("Failed to create Data object with error: \(error)")
                
                completion(nil, response, error)
            }
        }
    }

    task.resume()

    observeDownloadProgress(task)
}

func observeDownloadProgress(_ task: URLSessionDownloadTask) {
    let observation = task.progress.observe(\.fractionCompleted) { progress, _ in
        print("Download progress: \(progress.fractionCompleted * 100)%")
    }
}


import SwiftUI
import Alamofire
//#Preview {
//    ContentView()
//}
