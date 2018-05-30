//
//  NewsInfo.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import ObjectMapper

struct NewsInfo: Mappable {
    var id: String!
    var images: String!
    var title: String!
    var type: Int!

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        images <- map["images"]
        title <- map["title"]
        type <- map["type"]
    }

}
