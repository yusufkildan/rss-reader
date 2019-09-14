//
//  ReusableView.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

protocol ReusableView: class {}

extension ReusableView {
    /// Unique identifier for object
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

