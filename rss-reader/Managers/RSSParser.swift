//
//  RSSParser.swift
//  rss-reader
//
//  Created by yusuf_kildan on 12.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

enum ElementName: String {
    case item               = "item"
    case entry              = "entry"
    case title              = "title"
    case link               = "link"
    case guid               = "guid"
    case pubDate            = "pubDate"
    case description        = "description"
    case contentEncoded     = "content:encoded"
    case language           = "language"
    case lastBuildDate      = "lastBuildDate"
    case generator          = "generator"
    case copyright          = "copyright"
    case thumbnail          = "media:thumbnail"
    case content            = "content"
    case author             = "author"
    case comments           = "comments"
    case source             = "source"
    case published          = "published"
    case mediaContent       = "media:content"
    case enclosure          = "enclosure"
    case category           = "category"
}

class RSSParser: NSObject {

    var completionHandler: ((Result<FeedInfo, RSSFeedError>) -> Void)?

    var currentItem: FeedItem?
    var feed = FeedInfo()
    var currentElement = ""
    var currentAttributes: [String: String]?
    var parsingItems: Bool = false
    var rssFeed: RSSFeed?

    // MARK: - Constructors

    override init() {
        super.init()
    }

    // MARK: - Methods

    /// Parses rss feed
    ///
    /// - Parameters:
    ///   - feed: RSSFeed
    func parseFor(feed: RSSFeed, completionHandler: @escaping (Result<FeedInfo, RSSFeedError>) -> Void) {
        let request = URLRequest(url: URL(string: feed.url)!)
        self.rssFeed = feed
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                if error.code == NSURLErrorNotConnectedToInternet {
                    completionHandler(.failure(.notConnectedToInternet))
                } else {
                    completionHandler(.failure(.unknown))
                }
            } else if let data = data {
                self.completionHandler = completionHandler

                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }.resume()
    }
}

// MARK: - XMLParserDelegate

extension RSSParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {

    }

    func parserDidEndDocument(_ parser: XMLParser) {
        if let completionHandler = completionHandler {
            completionHandler(.success(feed))
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentAttributes = attributeDict
        currentElement = ""

        if elementName == ElementName.item.rawValue || elementName == ElementName.entry.rawValue {
            currentItem = FeedItem()
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == ElementName.item.rawValue || elementName == ElementName.entry.rawValue {
            if let item = currentItem {
                feed.items.append(item)
            }
            self.currentItem = nil
            return
        }

        if let item = currentItem {
            item.publisherName = rssFeed?.name
            switch elementName {
            case ElementName.title.rawValue:
                item.title = currentElement
            case ElementName.guid.rawValue:
                item.guid = currentElement
            case ElementName.pubDate.rawValue:
                item.pubDate = currentElement.toDate()
            case ElementName.description.rawValue:
                item.itemDescription = currentElement
            case ElementName.content.rawValue, ElementName.contentEncoded.rawValue:
                item.content = currentElement
            case ElementName.link.rawValue:
                item.link = URL(string: currentElement)
            case ElementName.author.rawValue:
                item.author = currentElement
            case ElementName.comments.rawValue:
                item.comments = currentElement
            case ElementName.source.rawValue:
                item.source = currentElement
            case ElementName.published.rawValue:
                item.pubDate = currentElement.toDate()
            case ElementName.thumbnail.rawValue:
                if let attributes = currentAttributes {
                    if let url = attributes["url"] {
                        item.mediaThumbnail = url
                    }
                }
            case ElementName.mediaContent.rawValue:
                if let attributes = currentAttributes {
                    if let url = attributes["url"] {
                        item.mediaContent = url
                    }
                }
            case ElementName.enclosure.rawValue:
                if let attributes = currentAttributes {
                    item.enclosures = (item.enclosures ?? []) + [attributes]
                }
            case ElementName.category.rawValue:
                if let attributes = currentAttributes {
                    item.categories = (item.categories ?? []) + [attributes]
                }
            default:
                break
            }
        } else {
            switch elementName {
            case ElementName.title.rawValue:
                feed.title = currentElement
            case ElementName.link.rawValue:
                feed.link = URL(string: currentElement)
            case ElementName.description.rawValue:
                feed.description = currentElement
            case ElementName.language.rawValue:
                feed.lang = currentElement
            case ElementName.lastBuildDate.rawValue:
                feed.lastBuildDate = currentElement.toDate()
            case ElementName.generator.rawValue:
                feed.generator = currentElement
            case ElementName.copyright.rawValue:
                feed.copyright = currentElement
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        currentElement += string
    }

    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {
        if let completionHandler = completionHandler {
            completionHandler(.failure(.parserFailed))
        }

        parser.abortParsing()
    }
}

