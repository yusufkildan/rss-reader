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
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

