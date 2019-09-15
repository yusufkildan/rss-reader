//
//  DataManager.swift
//  rss-reader
//
//  Created by yusuf_kildan on 14.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

class DataManager {
    /// Starts parsing the selected feeds asynchronously.
    /// Parsing runs on the background thread
    class func fetchNews(completionHandler: @escaping (Result<[FeedItem], RSSFeedError>) -> Void) {
        let queue = DispatchQueue(label: "com.yusufkildan.fetchNews.queue", qos: DispatchQoS.userInitiated)

        let dispatchGroup = DispatchGroup()
        var parseError: RSSFeedError?

        let selectedFeeds = getSelectedFeeds()

        var items: [FeedItem] = []

        selectedFeeds.forEach { feed in
            let parser = RSSParser()

            dispatchGroup.enter()
            queue.async {
                parser.parseFor(feed: feed) { (result) in
                    switch result {
                    case .success(let feedInfo):
                        items += feedInfo.items
                    case .failure(let error):
                        parseError = error
                    }

                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            items = items.sorted() // O(n log n) complexity

            let readedItems = getReadedNews()

            items = items.map {
                if readedItems.contains($0) {
                    $0.isReaded = true
                } else {
                    $0.isReaded = false
                }

                return $0
            }

            persistNews(items)

            if let parserError = parseError {
                completionHandler(.failure(parserError))
            } else {
                completionHandler(.success(items))
            }
        }
    }

    class func marksAsAReaded(_ item: FeedItem) {
        var readedNews: [FeedItem] = getReadedNews()
        readedNews.append(item)
        PersistanceManager.persist(readedNews, as: File.readedNews)
    }

    class func marksAsAUnreaded(_ item: FeedItem) {
        var readedNews: [FeedItem] = getReadedNews()
        if let index = readedNews.firstIndex(of: item)  {
            readedNews.remove(at: index)
        }
        PersistanceManager.persist(readedNews, as: File.readedNews)
    }

    class func getReadedNews() -> [FeedItem] {
        if PersistanceManager.fileExists(File.readedNews) {
            return PersistanceManager.retrieve(File.readedNews, as: [FeedItem].self)
        }

        return []
    }

    class func getSelectedFeeds() -> [RSSFeed] {
        if PersistanceManager.fileExists(File.feeds) {
            return PersistanceManager.retrieve(File.feeds, as: [RSSFeed].self).filter { $0.isSelected }
        }

        return []
    }

    class func getFeeds() -> [RSSFeed] {
        if PersistanceManager.fileExists(.feeds) {
            return PersistanceManager.retrieve(.feeds, as: [RSSFeed].self)
        } else {
            return [RSSFeed(id: 1, name: "CBS News", url: "https://www.cbsnews.com/latest/rss/technology"),
                    RSSFeed(id: 2, name: "New York Post", url: "https://nypost.com/living/feed/"),
                    RSSFeed(id: 3, name: "The Guardian", url: "https://www.theguardian.com/uk/sport/rss"),
                    RSSFeed(id: 4, name: "Wired", url: "https://www.wired.com/feed/category/culture/latest/rss"),
                    RSSFeed(id: 5, name: "Washington Post", url: "http://feeds.washingtonpost.com/rss/national"),
                    RSSFeed(id: 6, name: "CNN", url: "http://rss.cnn.com/rss/edition_world.rss"),
                    RSSFeed(id: 7, name: "ABC News", url: "https://abcnews.go.com/abcnews/entertainmentheadlines"),
                    RSSFeed(id: 8, name: "Mashable", url: "https://mashable.com/entertainment/rss/"),
                    RSSFeed(id: 9, name: "TIME", url: "https://feeds2.feedburner.com/timeblogs/keepingscore")]
        }
    }

    class func persistNews(_ news: [FeedItem]) {
        PersistanceManager.persist(news, as: File.latestNews)
    }

    class func getPersistedNews() -> [FeedItem] {
        if PersistanceManager.fileExists(File.latestNews) {
            var items = PersistanceManager.retrieve(File.latestNews, as: [FeedItem].self)
            let readedItems = getReadedNews()

            items = items.map {
                if readedItems.contains($0) {
                    $0.isReaded = true
                } else {
                    $0.isReaded = false
                }

                return $0
            }

            return items
        }

        return []
    }
}
