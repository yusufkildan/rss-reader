//
//  FeedInfo.swift
//  rss-reader
//
//  Created by yusuf_kildan on 12.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

class FeedInfo: Codable {
    var items: [FeedItem] = []
    var title: String?
    var link: URL?
    var description: String?
    var lang: String?
    var lastBuildDate: Date?
    var generator: String?
    var copyright: String?
}
