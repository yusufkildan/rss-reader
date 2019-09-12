//
//  CardView.swift
//  rss-reader
//
//  Created by yusuf_kildan on 11.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class CardView: UIView {

    var cornerRadius: CGFloat = 6.0

    var shadowOffsetWidth = 0.0
    var shadowOffsetHeight = 0.0
    var shadowColor: UIColor = ColorPalette.Primary.shadow
    var shadowOpacity: Float = 0.12
    var shadowRadius: CGFloat = 5.0

    // MARK: - Constructors

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = ColorPalette.Primary.Light.background
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds,
                                      cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth,
                                    height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
    }
}

