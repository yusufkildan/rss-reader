//
//  FeedSelectionCollectionViewCell.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class FeedSelectionCollectionViewCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    private var selectionIndicatorView: UIView!

    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderWidth = 3
                contentView.layer.borderColor = ColorPalette.Primary.blue.cgColor
                selectionIndicatorView.isHidden = false
            } else {
                contentView.layer.borderWidth = 0
                contentView.layer.borderColor = UIColor.clear.cgColor
                selectionIndicatorView.isHidden = true
            }
        }
    }

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
        contentView.backgroundColor = ColorPalette.Primary.Light.background
        contentView.layer.cornerRadius = 9.0
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 9).cgPath

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.avenirNextMediumFont(withSize: 16.0)
        titleLabel.textColor = ColorPalette.Primary.Light.text

        contentView.addSubview(titleLabel)

        let insets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: insets.left).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -insets.right).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: insets.top).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -insets.bottom).isActive = true

        selectionIndicatorView = UIView()
        selectionIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicatorView.backgroundColor = ColorPalette.Primary.blue.withAlphaComponent(0.3)
        selectionIndicatorView.isHidden = true

        contentView.addSubview(selectionIndicatorView)

        selectionIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        selectionIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        selectionIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        selectionIndicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
