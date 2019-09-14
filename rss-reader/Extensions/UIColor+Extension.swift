//
//  UIColor+Extension.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

struct ColorPalette {
    struct Primary {
        static let shadow = UIColor.black
        static let tint = UIColor.tundora
        static let blue = UIColor.blueRibbon
        
        struct Light {
            static let text = UIColor.doveGray
            static let background = UIColor.white
        }

        struct Dark {
            static let text = UIColor.tundora
        }
    }

    struct Secondary {
        static let shadow = UIColor.blueRibbon
        static let tint = UIColor.blueRibbon

        struct Light {
            static let text = UIColor.white
            static let background = UIColor.gallery
        }
    }
}

// MARK: - Private Colors

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.replacingOccurrences(of: "#", with: "")
        guard hex.count == 6, let hexValue = Int(hex, radix: 16) else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        self.init(red:   CGFloat( (hexValue & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hexValue & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hexValue & 0x0000FF) >> 0 ) / 255.0,
                  alpha: 1.0)
    }
}


private extension UIColor {
    /*
     For color naming conventions, an app called `Sip` was used.
     Link: https://sipapp.io
     */

    static var blueRibbon: UIColor {
        return UIColor(hexString: "#1B69FD")
    }

    static var tundora: UIColor {
        return UIColor(hexString: "#4A4A4A")
    }

    static var doveGray: UIColor {
        return UIColor(hexString: "#6B6B6B")
    }

    static var gallery: UIColor {
        return UIColor(hexString: "#EEEEEE")
    }
}
