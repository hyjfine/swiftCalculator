//
// Created by heyongjian on 2018/5/18.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsDetailInfo: Mappable {
    var body = String()
    var image_source: String?
    var title = String()
    var image: String?
    var share_url = String()
    var js = String()
    var recommenders = [[String: String]]()
    var ga_prefix = String()
    var type = Int()
    var id = Int()
    var css = [String]()

    func mapping(map: Map) {
        body <- map["body"]
        image_source <- map["image_source"]
        title <- map["title"]
        image <- map["image"]
        share_url <- map["share_url"]
        js <- map["js"]
        recommenders <- map["recommenders"]
        ga_prefix <- map["ga_prefix"]
        type <- map["type"]
        id <- map["id"]
        css <- map["css"]
    }

    required init?(map: Map) {

    }


}