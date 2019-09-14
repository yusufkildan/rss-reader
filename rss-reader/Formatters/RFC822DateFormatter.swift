//
//  RFC822DateFormatter.swift
//  rss-reader
//
//  Created by yusuf_kildan on 14.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

/// Converts date and time textual representations within the RFC822
/// date specification into `Date` objects
class RFC822DateFormatter: DateFormatter {

    let dateFormats = [
        "EEE, d MMM yyyy HH:mm:ss zzz",
        "EEE, d MMM yyyy HH:mm zzz",
        "d MMM yyyy HH:mm:ss Z"
    ]

    let backupFormats = [
        "d MMM yyyy HH:mm:ss zzz",
        "d MMM yyyy HH:mm zzz"
    ]

    override init() {
        super.init()
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.locale = Locale(identifier: "en_US_POSIX")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    private func attemptParsing(from string: String, formats: [String]) -> Date? {
        for dateFormat in formats {
            self.dateFormat = dateFormat
            if let date = super.date(from: string) {
                return date
            }
        }
        return nil
    }

    override func date(from string: String) -> Date? {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if let parsedDate = attemptParsing(from: string, formats: dateFormats) {
            return parsedDate
        }
        // See if we can lop off a text weekday, as DateFormatter does not
        // handle these in full compliance with Unicode tr35-31. For example,
        // "Tues, 6 November 2007 12:00:00 GMT" is rejected because of the "Tues",
        // even though "Tues" is used as an example for EEE in tr35-31.
        let trimRegEx = try! NSRegularExpression(pattern: "^[a-zA-Z]+, ([\\w :+-]+)$")
        let trimmed = trimRegEx.stringByReplacingMatches(in: string, options: [],
            range: NSMakeRange(0, string.count), withTemplate: "$1")
        return attemptParsing(from: trimmed, formats: backupFormats)
    }
}
