//
//  Utils.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class Utils {
    static var hasTopNotch: Bool {
        return Utils.safeAreaInsets.top > 20
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    }

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}
