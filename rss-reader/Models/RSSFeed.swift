//
//  RSSFeed.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

class RSSFeed: Codable {
    let id: Int
    let name: String
    let url: String
    var isSelected: Bool
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
        self.isSelected = false
    }
}
