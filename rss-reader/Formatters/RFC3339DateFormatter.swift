//
//  RFC3339DateFormatter.swift
//  rss-reader
//
//  Created by yusuf_kildan on 14.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

// Converts date and time textual representations within the RFC3339
/// date specification into `Date` objects
class RFC3339DateFormatter: DateFormatter {

    let dateFormats = [
        "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
        "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ"
    ]

    override init() {
        super.init()
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.locale = Locale(identifier: "en_US_POSIX")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    override func date(from string: String) -> Date? {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        for dateFormat in self.dateFormats {
            self.dateFormat = dateFormat
            if let date = super.date(from: string) {
                return date
            }
        }
        
        return nil
    }
}
