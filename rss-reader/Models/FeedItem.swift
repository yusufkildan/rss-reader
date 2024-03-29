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
    var pubDate: Date?
    var itemDescription: String? {
        didSet {
            if let itemDescription = itemDescription {
                imagesFromDescription = imagesFromHTMLString(itemDescription)
            }
        }
    }
    
    var content: String? {
        didSet {
            if let content = content {
                imagesFromContent = imagesFromHTMLString(content)
            }
        }
    }
    var author: String?
    var comments: String?
    var source: String?
    var mediaThumbnail: String?
    var mediaContent: String?
    var imagesFromDescription: [String]?
    var imagesFromContent: [String]?
    var enclosures: [[String: String]]?
    var categories: [[String: String]]?
    var isReaded: Bool = false
    var publisherName: String?

    /// Retrieves all the images (\<img\> tags) from a given String contaning HTML using a regex
    ///
    /// - Parameters:
    ///   - htmlString: A String containing HTML
    /// - Returns: an array of image url Strings ([String])
    private func imagesFromHTMLString(_ htmlString: String) -> [String] {
        let htmlNSString = htmlString as NSString
        var images: [String] = []
        
        
        if let regex = try? NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: [NSRegularExpression.Options.caseInsensitive]) {
            regex.enumerateMatches(in: htmlString, options: [NSRegularExpression.MatchingOptions.reportProgress], range: NSMakeRange(0, htmlString.count)) { (result, flags, stop) -> Void in
                if let range = result?.range {
                    images.append(htmlNSString.substring(with: range))
                }
            }
        }
        
        return images
    }
}

// MARK: - Equatable

extension FeedItem: Equatable {
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.title == rhs.title && lhs.guid == rhs.guid && lhs.link == rhs.link
    }
}

// MARK: - Comparable

extension FeedItem: Comparable {
    static func < (lhs: FeedItem, rhs: FeedItem) -> Bool {
        let lhsTimestamp = lhs.pubDate?.timeIntervalSince1970 ?? 0
        let rhsTimestamp = rhs.pubDate?.timeIntervalSince1970 ?? 0
        
        return lhsTimestamp > rhsTimestamp
    }

}
