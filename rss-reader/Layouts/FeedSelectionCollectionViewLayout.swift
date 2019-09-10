//
//  FeedSelectionCollectionViewLayout.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class FeedSelectionCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()

        let numberOfColumns: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            numberOfColumns = 4.0
        } else {
            numberOfColumns = 3.0
        }

        let insets = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 12.0, right: 8.0)
        let interingSpacing: CGFloat = 8.0
        let lineSpacing: CGFloat = 25.0
        let availableWidth = Utils.screenWidth - insets.left - insets.right - (numberOfColumns - 1) * interingSpacing
        let itemDimension = availableWidth / numberOfColumns

        itemSize = CGSize(width: itemDimension, height: itemDimension)
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = interingSpacing
        sectionInset = insets
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
