//
//  PlayRateControl.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit
//支持更多（长按选择）
@available(watchOS 10.0, *)
enum Universal的倍速:Double {
    case 零点五 = 0.5
    case 零点七五 = 0.75
    case 一点零 = 1.0
    case 一点五 = 1.5
    case 两倍 = 2.0
    
}

@available(watchOS 10.0, *)
struct Universal的倍速开关: View {
    var SFName:String = "speedometer"
    @State var scBut = false
    @State var downTime = Date()
    let cancellableTask = CancellableTask()
    @State var canAction = true
    @AppStorage("choicedVideoPlaySpeed") var
    choicedSpeed: Double = 1.0
    var body: some View {
        HStack {
            
                
                //弹幕开关
                Color.touchZone
                    .frame(width: 44, height: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(content: {
                        ZStack {
                            Image(systemName: SFName)
                            VStack {
                                Spacer()
                                HStack{
                                    Spacer()
                                    let sfsymbol:String = {
                                        let nSpeed = Universal的倍速.init(rawValue: choicedSpeed)
                                        switch nSpeed {
                                        case .零点五:
                                            return "05.square.fill"
                                        case .零点七五:
                                            return "07.square.fill"
                                        case .一点零:
                                            return "1.square.fill"
                                        case .一点五:
                                            return "15.square.fill"
                                        case .两倍:
                                            return "2.square.fill"
                                        case .none:
                                            return ""
                                        }
                                    }()
                                    Image(systemName:  sfsymbol)
                                        .imageScale(.small)
                                    
                                }
                                .padding([.bottom,.trailing],5)
                            }
                        }   .contentTransition(.symbolEffect(.automatic))
                    })
                
                    .beButton {
                        printLog("触摸到了按钮，当前点击")
                        cancellableTask.cancel()
                        if canAction {
                            switchSpeed()
                        } else {
                            canAction = true
                        }
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showSheet, content: {
                        SwipeSheet(showMe: $showSheet, content: { name,action in
                            Universal的倍速ChoiceView(name: name, action: action)
                            
                        })
                    })
                    .onChange(of: showSheet, perform: { value in
                        if value {
                            
                        } else {
                            if let currentIndex = choicedSpeeds.firstIndex(of: choicedSpeed) {
                                
                            } else {
                                choicedSpeed = 1.0
                            }
                        }
                    })
                Color.touchZone
                    .frame(width: screenBound.width-40, height: 40)
                    .overlay(content: {
                        Button(action: {
                            showSheet.toggle()
                        }, label: {
                            Text("点击左侧切换，点我设置")
                                .font(.footnote)
                        })
                   
                    })
                //弹幕开关
            
        }
    }
    let screenBound = WKInterfaceDevice.current().screenBounds
    @State var showSheet = false
    //监听按钮点击事件，根据当前speed的值切换到下一个速度
    func switchSpeed() {
        if choicedSpeeds.count <= 1 {
            提示OS("您当前仅开启了一倍速\n长按倍速开关选择更多")
        }
        if let currentIndex = choicedSpeeds.firstIndex(of: choicedSpeed) {
            //若当前speed为数组的最后一个元素，则切换到第一个速度，否则切换到下一个速度
            choicedSpeed = choicedSpeeds[(currentIndex + 1) % choicedSpeeds.count]
            //存储选中的速度
            //            choicedSpeed = speed.rawValue
        } else {
            choicedSpeed = 1.0
            
        }
    }
    @AppStorage("choicedVideoPlaySpeeds") var
choicedSpeeds: [Double] = [0.5,1.0,2]
    //    let speeds: [倍速] = [.零点五, .零点七五, .一点零, .一点五, .两倍]
}

@available(watchOS 10.0, *)
struct Universal的倍速ChoiceView: View {
    
    var name:UUID
    //    var nav:Bool = false
    var action: (CGRect) -> Void
    let speeds: [Universal的倍速] = [.零点五, .零点七五, .一点零, .一点五, .两倍]
    
    
    
    //    @State var allSpeed = [0.5,0.75,1,1.5,2]
    @AppStorage("choicedVideoPlaySpeeds") var
choicedSpeeds: [Double] = [0.5,1.0,2]
    var body: some View {
        List {
            ForEach(speeds,id:\.self, content: { eachSpeed in
                let me = choicedSpeeds.contains(eachSpeed.rawValue)
                let 是75 = eachSpeed == .零点七五
                let 是第一 = eachSpeed == .零点五
                Label("\(eachSpeed.rawValue)".prefix(是75 ? 4 : 3), systemImage: me ? "checkmark" : "circlebadge").leadingText()
                    .beButton {
                        let me = choicedSpeeds.contains(eachSpeed.rawValue)
                        if me {
                            let meIndex = choicedSpeeds.firstIndex(of: eachSpeed.rawValue)!
                            choicedSpeeds.remove(at: meIndex)
                        } else {
                            choicedSpeeds.append(eachSpeed.rawValue)
                        }
                    }
                    .if(是第一, transform: { v in
                        v
                            .actionOn(name: name, action: action)
                    })
            })
        }
    }
}

