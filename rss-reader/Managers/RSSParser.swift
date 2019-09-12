//
//  RSSParser.swift
//  rss-reader
//
//  Created by yusuf_kildan on 12.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

enum ElementName: String {
    case item          = "item"
    case title         = "title"
    case link          = "link"
    case guid          = "guid"
    case pubDate       = "pubDate"
    case description   = "description"
    case content       = "content:encoded"
    case language      = "language"
    case lastBuildDate = "lastBuildDate"
    case generator     = "generator"
    case copyright     = "copyright"
    case thumbnail     = "mash:thumbnail"
}

class RSSParser: NSObject {

    var completionHandler: ((FeedInfo?, Error?) -> Void)?
    var currentItem: FeeedItem?
    var feed = FeedInfo()
    var currentElement = ""

    // MARK: - Constructors

    override init() {
        super.init()
    }

    // MARK: - Methods

    func parseFor(request: URLRequest, completionHandler: ((FeedInfo?, Error?) -> Void)?) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler?(nil, error)
            } else if let data = data {
                self.completionHandler = completionHandler

                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.shouldResolveExternalEntities = false
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
            completionHandler(feed, nil)
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == ElementName.item.rawValue {
            currentItem = FeeedItem()
        }

        currentElement = ""
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == ElementName.item.rawValue {
            if let item = currentItem {
                if let content = item.content {
                    var imageURLs = content.imageURLsFromHTMLString

                    if imageURLs.isEmpty {
                        if let description = item.itemDescription {
                            imageURLs = description.imageURLsFromHTMLString
                        }
                    }

                    item.imageURLs = imageURLs
                }


                feed.items.append(item)
            }

            self.currentItem = nil
            return
        }

        if let item = currentItem {
            switch elementName {
            case ElementName.title.rawValue:
                item.title = currentElement
            case ElementName.guid.rawValue:
                item.guid = currentElement
            case ElementName.pubDate.rawValue:
                item.pubDate = currentElement // TODO
            case ElementName.description.rawValue:
                item.itemDescription = currentElement
            case ElementName.content.rawValue:
                item.content = currentElement
            case ElementName.link.rawValue:
                item.link = URL(string: currentElement)
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
                feed.lastBuildDate = currentElement // TODO
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
            completionHandler(nil, parseError)
        }
    }
}

