//
//  String+Extension.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

extension String {
    static func localize(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    func toDate() -> Date? {
        return RFC822DateFormatter().date(from: self) ??
            (RFC3339DateFormatter().date(from: self) ??
            ISO8601DateFormatter().date(from: self))
    }
}
