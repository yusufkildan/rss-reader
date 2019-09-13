//
//  FeedItem.swift
//  rss-reader
//
//  Created by yusuf_kildan on 12.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

class FeedItem: Codable {
    var title: String?
    var link: URL?
    var guid: String?
    var pubDate: String?
    var itemDescription: String?
    var content: String?
    var imageURLs: [URL]?
}
