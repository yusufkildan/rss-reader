//
//  NewsListTableViewCell.swift
//  rss-reader
//
//  Created by yusuf_kildan on 11.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {
    private var containerView: CardView!
    var thumbnailImageView: UIImageView!
    private var titleLabel: UILabel!
    private var publishInfoLabel: UILabel!

    var thumbnailImage: UIImage! {
        didSet {
            thumbnailImageView.image = thumbnailImage
        }
    }

    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    var publishInfo: String! {
        didSet {
            publishInfoLabel.text = publishInfo
        }
    }

    var attributedPublishInfo: NSAttributedString! {
        didSet {
            publishInfoLabel.attributedText = attributedPublishInfo
        }
    }

    // MARK: - Constructors

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        containerView = CardView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)

        let cardViewInsets = UIEdgeInsets(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: cardViewInsets.left).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -cardViewInsets.right).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: cardViewInsets.top).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -cardViewInsets.bottom).isActive = true

        let thumbnailImageViewDimension: CGFloat = 63.0
        thumbnailImageView = UIImageView()
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = ColorPalette.Secondary.Light.background
        thumbnailImageView.contentMode = UIView.ContentMode.scaleAspectFill
        thumbnailImageView.layer.cornerRadius = thumbnailImageViewDimension / 2.0
        thumbnailImageView.layer.masksToBounds = true

        containerView.addSubview(thumbnailImageView)

        let thumbnailImageViewInsets = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 8.0)
        thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                constant: thumbnailImageViewInsets.top).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                     constant: -thumbnailImageViewInsets.right).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailImageViewDimension).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailImageViewDimension).isActive = true

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = ColorPalette.Primary.Dark.text
        titleLabel.font = UIFont.avenirNextDemiboldFont(withSize: 16.0)
        titleLabel.numberOfLines = 0

        publishInfoLabel = UILabel()
        publishInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        publishInfoLabel.textColor = ColorPalette.Primary.Light.text
        publishInfoLabel.font = UIFont.avenirNextRegularFont(withSize: 16.0)
        publishInfoLabel.numberOfLines = 0

        let labelContainerView = UIStackView(arrangedSubviews: [titleLabel, publishInfoLabel])
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.alignment = UIStackView.Alignment.fill
        labelContainerView.axis = NSLayoutConstraint.Axis.vertical
        labelContainerView.distribution = UIStackView.Distribution.fill
        labelContainerView.spacing = 12.0
        
        containerView.addSubview(labelContainerView)

        let labelContainerViewInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0)
        labelContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                    constant: labelContainerViewInsets.left).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor,
                                                     constant: -labelContainerViewInsets.right).isActive = true
        labelContainerView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                constant: labelContainerViewInsets.top).isActive = true
        labelContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                   constant: -labelContainerViewInsets.bottom).isActive = true
        labelContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: thumbnailImageViewDimension).isActive = true
    }

    // MARK: - Prepare

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}
