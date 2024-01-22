//
//  FlyCommentDownloader.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import Foundation
//
//  弹幕下载器.swift
//  WatchBili Watch App
//
//  Created by 凌嘉徽 on 2023/9/18.
//

import Foundation
//
//  弹幕缓存器.swift
//  Sustainably Watch App
//
//  Created by 凌嘉徽 on 2023/8/27.
//

import Foundation
import Cache

//新下载器/开始下载
struct DanmuOffLineData:Identifiable,Codable {
    var id = UUID()
    var belongCID:Int64
    var allPacksCount:Int
    var dmPacks:[DanmuEachPack] = []
    func 完成度() -> Double {
        let 现有 = dmPacks.removeDuplicates(包含函数: { all,me in
            if let you = all.first(where: { e in
                e.myPackIndex == me.myPackIndex
            }) {
                return true
            } else {
                return false
            }
        }).filter { e in
            e.dmData != nil
        }.count
        print("总分包\(allPacksCount)")
        printLog("现有\(现有)")
        return Double(现有)/Double(allPacksCount)
    }
}

struct DanmuEachPack:Identifiable,Hashable,Equatable,Codable {
    var id = UUID()
    var myPackIndex:Int
    var dmData:Data?
    var downloadDate = Date()
}

class 弹幕视频下载Mod: ObservableObject {
    let storage:AsyncStorage<Int64, DanmuOffLineData>!
    let name = "DanmuDownload"
    func 添加一个Obj(cid:Int64,obj:DanmuOffLineData) {
        storage.setObject(obj, forKey: cid, completion: { res in
            switch res {
            case .value(let v):
                print(v)
            case .error(let e):
                print(e.localizedDescription)
            }
        })
    }
    init() {
        let oneMB = 1024 * 1024
        let memoryConfig = MemoryConfig(expiry: .seconds(60), countLimit: 0, totalCostLimit: UInt(oneMB))
        let memoryStorage = MemoryStorage<Int64, DanmuOffLineData>(config: memoryConfig)
        let diskConfig = DiskConfig(name: name)
        let transformer = TransformerFactory.forCodable(ofType: DanmuOffLineData.self)
        let diskStorage = try! DiskStorage<Int64, DanmuOffLineData>(config: diskConfig, transformer: transformer)
        let hybrid = HybridStorage(memoryStorage: memoryStorage, diskStorage: diskStorage)
        let async = AsyncStorage(storage: hybrid, serialQueue: .main)
        storage = async
    }
    func 获取Obj(cid:Int64) async throws -> DanmuOffLineData {
        try await withUnsafeThrowingContinuation { c in
            storage.object(forKey: cid, completion: { res in
                switch res {
                case .value(let t):
                    c.resume(returning: t)
                case .error(let error):
                    c.resume(throwing: error)
                }
            })
        }
    }
    func clean() {
        storage.removeAll(completion: { res in
            switch res {
            case .value(let v):
                print(v)
            case .error(let e):
                print(e.localizedDescription)
            }
        })
    }
}
