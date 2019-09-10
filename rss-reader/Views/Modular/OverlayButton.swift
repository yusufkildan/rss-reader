//
//  OverlayButton.swift
//  rss-reader
//
//  Created by yusuf_kildan on 11.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class OverlayButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled == true {
                self.alpha = 1.0
            } else {
                self.alpha = 0.5
            }
        }
    }
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = ColorPalette.Primary.blue
        titleLabel?.font = UIFont.avenirNextBoldFont(withSize: 18.0)
        titleLabel?.textColor = ColorPalette.Secondary.Light.text
        tintColor = UIColor.white
        
        layer.masksToBounds = false
        layer.shadowColor = ColorPalette.Secondary.shadow.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 6.0
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = self.frame.size.height / 2.0
        
        layer.cornerRadius = cornerRadius
    }
}

