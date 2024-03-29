//
//  Date+Extension.swift
//  rss-reader
//
//  Created by yusuf_kildan on 14.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

extension Date {
    static func timePassedSinceDate(_ date: Date) -> String {
        let secondsPassed = -1 * date.timeIntervalSinceNow

        if secondsPassed < 60 {
            let time = Int(secondsPassed)

            if time == 1 {
                return String(format: String.localize("one_sec"), time)
            } else {
                return String(format: String.localize("secs"), time)
            }
        }

        if secondsPassed < (60 * 60) {
            let time = Int(secondsPassed / 60)

            if time == 1 {
                return String(format: String.localize("one_min"), time)
            }

            return String(format: String.localize("mins"), time)
        }

        if secondsPassed < (60 * 60 * 24) {
            let time = Int(secondsPassed / ( 60 * 60))

            if time == 1 {
                return String(format: String.localize("one_hour"), time)
            }

            return String(format: String.localize("hours"), time)
        }

        if secondsPassed < (60 * 60 * 24 * 7) {
            let time = Int(secondsPassed / (60 * 60 * 24))

            if time == 1 {
                return String(format: String.localize("one_day"), time)
            }

            return String(format: String.localize("days"), time)
        }

        let time = Int(secondsPassed / (60 * 60 * 24 * 7))

        if time == 1 {
            return String(format: String.localize("one_week"), time)
        }

        if time > 4 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"

            return formatter.string(from: date)
        }

        return String(format: String.localize("weeks"), time)
    }
}
