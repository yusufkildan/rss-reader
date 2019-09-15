//
//  ParserError.swift
//  rss-reader
//
//  Created by yusuf_kildan on 15.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

enum RSSFeedError: Error {
    case unknown
    case notConnectedToInternet
    case parserFailed

    var localizedDescription: String {
        switch self {
        case .unknown, .parserFailed:
            return String.localize("unknown_error_description")
        case .notConnectedToInternet:
            return String.localize("not_connected_to_internet_error_description")
        }
    }
}
