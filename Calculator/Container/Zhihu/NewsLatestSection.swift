//
//  NewsLatestSection.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/30.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import Differentiator
import RxDataSources

struct NewsLatestSection {
    var header: String
    var items: [Item]
}

extension NewsLatestSection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: NewsLatestSection, items: [Item]) {
        self = original
        self.items = items
    }
}
