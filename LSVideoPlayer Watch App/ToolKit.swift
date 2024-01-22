//
//  ToolKit.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/22.
//

import Foundation
import SwiftUI
import AVFoundation
extension Array where Element: Hashable {
    
    ///正序保留最上面一个
    func removeDuplicates(倒序:Bool = false) -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in ((倒序.not) ? self : self.reversed()) {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    //例子
//    dmPacks.removeDuplicates(包含函数: { all,me in
//        if let you = all.first(where: { e in
//            e.myPackIndex == me.myPackIndex
//        }) {
//            return true
//        } else {
//            return false
//        }
//    })
    func removeDuplicates(倒序:Bool = false,包含函数:(Set<Element>,Element) -> (Bool)) -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in ((倒序.not) ? self : self.reversed()) {
            if !包含函数(added,elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
}
func normalize(_ value: Int, to range: ClosedRange<Int> = 0...1) -> Int {
    if value < range.lowerBound {
        return range.lowerBound
    }
    if value > range.upperBound {
        return range.upperBound
    }
    return value
}
func normalize(_ value: Double, to range: ClosedRange<Double> = 0...1) -> Double {
    if value < range.lowerBound {
        return range.lowerBound
    }
    if value > range.upperBound {
        return range.upperBound
    }
    return value
}
func normalize(_ value: Float, to range: ClosedRange<Float> = 0...1) -> Float {
    if value < range.lowerBound {
        return range.lowerBound
    }
    if value > range.upperBound {
        return range.upperBound
    }
    return value
}
extension Bool {
    var not:Bool {
        return !self
    }
}
struct SyncValue<T:Equatable>: ViewModifier {
    var volume:T?
    var action:(T) -> ()
    func body(content: Content) -> some View {
        content
            .onAppear {
                if let volume {
                    action(volume)
                }
            }
            .onChange(of: volume) { value in
                if let volume {
                    action(volume)
                }
            }
            
    }
}

extension View {
    
    ///不建议使用perform内的值！
    @ViewBuilder
    func syncValue<T:Equatable>(of:T?,perform:@escaping (T)->()) -> some View {
        self
            .modifier(SyncValue(volume: of, action: perform))
    }
}
extension Date {
    static func getCurrentTimeInMMDDFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM:dd"
        
        // 使用用户设定的时区
         let userTimeZone = TimeZone.current.identifier //{
         dateFormatter.timeZone = TimeZone(identifier: userTimeZone)
//        }
        
        let currentTime = Date()
        let timeString = dateFormatter.string(from: currentTime)
        
        return ""//timeString
    }
}
extension View {
    @ViewBuilder func leadingText() -> some View {
        HStack {
            self
            Spacer()
        }
    }
}
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension Color {
    public static var touchZone: Image {
        .init(uiImage: .init(color: .clear)!)
        .resizable()
    }
}
class LionAudioToolKit {
    
    ///0到100
    static func currentSystemVolume() -> Int {
        Int(round(AVAudioSession.sharedInstance().outputVolume*100))
    }
    static func currentSystemVolumeDouble() -> Double {
        Double(AVAudioSession.sharedInstance().outputVolume)
    }
    //判断静音模式
    static func slicetMode() -> Bool {
        AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        
    }
}
// MARK: - 视图生命周期扩展
extension View {
    public func onLoad(操作:@escaping () -> ()) -> some View {
        self
            .modifier(onFirstAppear(操作: 操作))
    }
}

struct onFirstAppear: ViewModifier {
    
    @State private var 显示过了 = false
    
    @State var 操作:() -> ()
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                if !显示过了 {
                    显示过了 = true
                    操作()
                }
            })
    }
}
func MainActor(_ Closures:@escaping ()->()) {
    DispatchQueue.main.async {
        Closures()
    }
}
enum 错误: LocalizedError,Equatable {
    
    ///最常见的提示
    case 消息(message: String)
    
    case 反馈(message:String)
    
    case 网络(message: String)
    
    case http错误码(码:Int)
    
    case 参数错误
    
    
    case bili未登录
    
    static var 网络错误 = 错误.消息(message: "连接服务器失败，请检查你的网络链接（如试试Siri是否可正常响应），如果多次失败，请添加微信公众号“腕上RSS联系客服”")
    
    public var errorDescription: String? {
        switch self {
        case .网络(message: let message):
            return "请检查你的网络连接\n\(message)"
        case .反馈(message: let message):
            return "\(message)\n请反馈给开发者"
        case .消息(message: let message):
            return "\(message)"
        case .http错误码(码: let code):
            return "请求失败：\(code)"
        case .参数错误:
            return "app内部错误，请通过QQ：3245146430联系开发者"
        case .bili未登录:
            return "请在本app中登录哔哩哔哩账号"
        }
    }
    
}
extension Collection {
    /**
     如果元素在边界内，则返回指定索引处的元素，否则为nil。
     ```
     let 集合 = [1,2]
     let 结果 = 集合.at(2)
     print(结果)
     */
    public func safe(_ index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    
}
func printLog(_ message:Any) {
    print(message)
}
class CancellableTask {
    private var workItem: DispatchWorkItem?
    
    func performDelayedOperation(after: TimeInterval, handler: @escaping () -> Void) {
        // 取消之前的 workItem，如果有的话
        workItem?.cancel()
        
        // 创建一个新的 DispatchWorkItem
        let new = DispatchWorkItem {
            handler()
        }
//        MainActor {
            self.workItem = new
//            printLog("创建成功！")
//        }
        
        // 使用异步延迟将 workItem 添加到队列
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: new)
    }
    
    func cancel() {
        if let workItem {
            workItem.cancel()
            self.workItem = nil
        } else {
            print("你正在取消不存在的")
        }
    }
}

extension View {
    @ViewBuilder func beButton(_ toDo:@escaping () -> ()) -> some View {
        Button(action: toDo) {
            self
        }
    }
}
struct SwipeSheet<V:View>: View {
    @Binding var showMe:Bool
    let screenHeight = WKInterfaceDevice.current().screenBounds.height
    @State var 系数 = 0.0
    @AppStorage("SwipeSheetApearCount") var swipeSheetApearCount = 0
    @State var startY:CGFloat?
    var content: (UUID,@escaping (CGRect) -> Void) -> V
    let name = UUID()
    var body: some View {
        ZStack {
            VStack {
                if #available(watchOS 9, *) {
                    Image(systemName: "chevron.compact.down")
                        .bold()
                        .font(.title)
                        .padding(5)
                        .offset(y:系数*35)
                } else {
                    Image(systemName: "chevron.compact.down")
//                        .bold()
                        .font(.title)
                        .padding(5)
                        .offset(y:系数*35)
                }
                Text("继续下拉以返回")
                    .font(.caption2)
                    .offset(y:系数*35)
                Spacer()
            }
            .opacity(系数/1.2)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            VStack {
                
                content(name) { rect in
                   let minY = rect.minY
//                    printLog(minY)
                   if let startY {
                       计算手势(currentY: minY)
                       
                   } else {
                       startY = minY
                   }
               }
            }
//            ZStack {
//                Rectangle()
//                        .fill(Color.blue.LSgradient)
//            }
//                .mask {
//                    ZStack {
//                        VStack {
//                            ZStack {
//                                Color.white
//                                Color.black
//                                    .offset(x: 0, y: screenHeight*系数)
//                            }
//                            .compositingGroup()
//                            .luminanceToAlpha()
//                            .allowsHitTesting(false)
//                        }
//                        VStack {
//                            Spacer()
//                            Text("继续下拉以返回")
//
//                        }
//                    }
//                }
                
                
//            .mask {
//
//
//            }
            
        }
        .coordinateSpace(name:name)
        .navigationBarHidden(true)
        .animation(.easeInOut, value: 系数)
    }
    func 计算手势(currentY:CGFloat) {
        if let startY {
            if 系数 >= 1 {
                showMe = false
            }
            let 总量 = screenHeight/6.7//屏幕的三分之一高度
            let 向下距离 = currentY - startY
//            printLog(向下距离)
            let 系数 = 向下距离/总量
            self.系数 = 系数
        }
        
    }
}
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    func readSize1(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey1.self, value: geometryProxy.frame(in: .named("stack")))
            }
        )
        .onPreferenceChange(SizePreferenceKey1.self, perform: onChange)
    }
}
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
private struct SizePreferenceKey1: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
private struct PositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
extension NSObject {
    //避免普通项目冲突
//   @objc class func sharedApplication() -> NSObject? { fatalError() }
   
   @objc func keyWindow() -> NSObject? { fatalError() }
   @objc func rootViewController() -> NSObject? { fatalError() }
   @objc func presentedViewController() -> NSObject? { fatalError() }
   @objc func layer() -> NSObject? { fatalError() }
   
   @objc func viewControllers() -> [NSObject]? { fatalError() }
   @objc func view() -> NSObject? { fatalError() }
   @objc func tag() -> NSObject? { fatalError() }
   
   @objc func configuration() -> NSObject? { fatalError() }
   @objc func initialURL() -> NSObject? { fatalError() }
   @objc func subviews() -> [NSObject]? { fatalError() }
   @objc func timeLabel() -> NSObject? { fatalError() }
   @objc func setOpacity(_ opacity: CDouble) { fatalError() }
   @objc func setAlpha(_ alpha: CGFloat) { fatalError() }
   
   @objc func setTextColor(_ textColor: UIColor) { fatalError() }
   @objc func setTintColor(_ tintColor: UIColor) { fatalError() }
   @objc func setTag(_ tag: Int) { fatalError() }
    @objc func setValue(_ value: Float) { fatalError() }
}
// MARK: - 下划收起
struct PackInScrollView: ViewModifier {
var name:UUID
//    var nav:Bool = false
    var action: (CGRect) -> Void
    @State var mySpace:CGSize = .init(width: 1, height: 1)
    func body(content: Content) -> some View {
        ZStack {
            Color.clear.ignoresSafeArea(.container, edges: .vertical)
                .readSize(onChange: { s in
                    mySpace = s
                })
            ScrollView {
                ZStack {
                    Color.clear.ignoresSafeArea()
                        .frame(width: mySpace.width, height: mySpace.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    VStack {
                        Color.clear
                            .frame(height: 1, alignment: .top)
                            .actionOn(name:name,action: action)
                        Spacer()
                    }
                    VStack {
                        content
                            .ignoresSafeArea(.container, edges: .vertical)
                            //.ignoresSafeArea(.container, edges: .vertical)
                          //  .ignoresSafeArea(.container, edges: .vertical)
                            .frame(width: mySpace.width, height: mySpace.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } // .ignoresSafeArea(.container, edges: .vertical)
                }  .ignoresSafeArea(.container, edges: .vertical)
                //.ignoresSafeArea(.container, edges: .vertical) // .ignoresSafeArea(.container, edges: .vertical)
            }  .ignoresSafeArea(.container, edges: .vertical)
            //.ignoresSafeArea(.container, edges: .vertical) //.ignoresSafeArea(.container, edges: .vertical)
//            .if(nav) {
//                $0
//                    .embedNagivation()
//            }
        }
//        .navigationBarHidden(true)
            .ignoresSafeArea(.container, edges: .vertical)
           //
    }
}
extension View {
    
    func readPosition(in coordinateSpace:CoordinateSpace = .global,onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: PositionPreferenceKey.self, value: geometryProxy.frame(in: coordinateSpace))
            }
        )
        .onPreferenceChange(PositionPreferenceKey.self, perform: onChange)
    }
    func readPosition(in coordinateSpace:CoordinateSpace = .global,ifInscreen: @escaping () -> Void,outScreen: @escaping () -> Void = {}) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: PositionPreferenceKey.self, value: geometryProxy.frame(in: coordinateSpace))
            }
        )
        .onPreferenceChange(PositionPreferenceKey.self, perform: { rect in
            var screen:CGRect = .infinite
            screen = WKInterfaceDevice.current().screenBounds
//            printLog("视图中心",rect.center)
            if screen.intersects(rect) || screen.contains(rect.center) {
               
                ifInscreen()
            } else {
                outScreen()
            }
        })
    }

}
extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
extension View {
    @ViewBuilder
    func actionOn(name:UUID,action:@escaping (CGRect) -> Void) -> some View {
        self
            .readPosition(in:.named(name),onChange: action)
    }
}
public func DispatchAfter(after: Double, handler:@escaping ()->())
{
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        handler()
    }
}
