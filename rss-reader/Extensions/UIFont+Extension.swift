//
//  UIFont+Extension.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

extension UIFont {
    // MARK: - Avenir Next Fonts

    public class func avenirNextBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }

    public class func avenirNextDemiboldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size)!
    }

    public class func avenirNextMediumFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }

    public class func avenirNextHeavyFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Heavy", size: size)!
    }

    public class func avenirNextRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
}
