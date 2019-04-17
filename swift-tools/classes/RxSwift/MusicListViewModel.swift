//
//  MusicListViewModel.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/25.
//  Copyright © 2018 Hoa. All rights reserved.
//

import Foundation
import RxSwift

struct MusicListViewModel {
    
    /// 歌曲列表数据源
    let data = Observable.just([
        Music(name: "七里香", singer: "周杰伦"),
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树")
    ])
    
    let publicData = PublishSubject<Music>()
    
    let behaviorData = BehaviorSubject<Music>(value: Music(name: "在木星", singer: "朴树"))

}
