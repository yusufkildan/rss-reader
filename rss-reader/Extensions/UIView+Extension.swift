//
//  UIView+Extension.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

extension UIView: ReusableView {}

extension UIView {
    func addSketchShadow(color: UIColor,
                         alpha: Float,
                         x: CGFloat,
                         y: CGFloat,
                         blur: CGFloat,
                         spread: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func hideSketchShadow() {
        layer.shadowOpacity = 0
    }
}
