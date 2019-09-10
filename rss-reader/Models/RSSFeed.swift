//
//  RSSFeed.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

class RSSFeed {
    let name: String
    let url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }

    class func getFeeds() -> [RSSFeed] {
        return [RSSFeed(name: "CBS News", url: "https://www.cbsnews.com/latest/rss/technology"),
                RSSFeed(name: "New York Post", url: "https://nypost.com/living/feed/"),
                RSSFeed(name: "The Guardian", url: "https://www.theguardian.com/uk/sport/rss"),
                RSSFeed(name: "Wired", url: "https://www.wired.com/feed/category/culture/latest/rss"),
                RSSFeed(name: "Washington Post", url: "http://feeds.washingtonpost.com/rss/national"),
                RSSFeed(name: "CNN", url: "http://rss.cnn.com/rss/edition_world.rss"),
                RSSFeed(name: "ABC News", url: "https://abcnews.go.com/abcnews/entertainmentheadlines"),
                RSSFeed(name: "Mashable", url: "https://mashable.com/entertainment/rss/"),
                RSSFeed(name: "TIME", url: "https://feeds2.feedburner.com/timeblogs/keepingscore")]
    }
}
