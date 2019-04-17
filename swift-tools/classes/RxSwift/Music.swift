//
//  Music.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/25.
//  Copyright © 2018 Hoa. All rights reserved.
//

import Foundation

public struct Music {
    
    let name: String // 歌名
    let singer: String // 演唱者
}
extension Music: CustomStringConvertible {
    
    public var description: String {
        return "name: \(name) singer: \(singer)"
    }
}
