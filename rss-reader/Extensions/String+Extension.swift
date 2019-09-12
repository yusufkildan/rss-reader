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

    /*
     https://stackoverflow.com/questions/14505764/how-to-get-all-img-src-of-a-web-page-in-ios-uiwebview
     */
    var imageURLsFromHTMLString: [URL] {
        var urls: [URL] = []
        
        if let regex = try? NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: NSRegularExpression.Options.caseInsensitive) {
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.count)) { (result, _, _) in
                if let result = result {
                    let urlString = (self as NSString).substring(with: result.range) as String
                    urls.append(URL(string: urlString)!)
                }
            }
        }

        return urls
    }
}
