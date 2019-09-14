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
}
