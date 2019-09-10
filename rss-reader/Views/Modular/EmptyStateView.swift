//
//  EmptyStateView.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    var actionButton: UIButton!
    
    var icon: UIImage? {
        didSet {
            iconImageView.isHidden = icon == nil
            iconImageView.image = icon
        }
    }
    
    var title: String? {
        didSet {
            if let title = title {
                titleLabel.text = title
                titleLabel.isHidden = false
            } else {
                titleLabel.isHidden = true
            }
        }
    }
    
    var subtitle: String? {
        didSet {
            if let subtitle = subtitle {
                subtitleLabel.text = subtitle
                subtitleLabel.isHidden = false
            } else {
                subtitleLabel.isHidden = true
            }
        }
    }
    
    var actionButtonTitle: String? {
        didSet {
            actionButton.isHidden = actionButtonTitle == nil
            actionButton.setTitle(actionButtonTitle, for: UIControl.State.normal)
        }
    }
    
    weak var delegate: EmptyStateViewDelegate?
    
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
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = ColorPalette.Primary.Dark.text
        titleLabel.font = UIFont.avenirNextBoldFont(withSize: 20.0)
        titleLabel.textAlignment = NSTextAlignment.center
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = ColorPalette.Primary.Light.text
        subtitleLabel.font = UIFont.avenirNextRegularFont(withSize: 18.0)
        subtitleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000.0), for: NSLayoutConstraint.Axis.vertical)
        subtitleLabel.textAlignment = NSTextAlignment.center
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.alignment = .center
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing = 8.0
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = true
        iconImageView.contentMode = UIView.ContentMode.scaleAspectFit
        iconImageView.isHidden = true
        
        actionButton = OverlayButton(type: UIButton.ButtonType.system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = UIFont.avenirNextBoldFont(withSize: 18.0)

        actionButton.isHidden = true
        actionButton.setTitleColor(ColorPalette.Secondary.Light.text, for: UIControl.State.normal)
        actionButton.titleLabel?.font = UIFont.avenirNextBoldFont(withSize: 18.0)
        actionButton.addTarget(self,
                               action: #selector(actionButtonTapped(_:)),
                               for: UIControl.Event.touchUpInside)
        
        actionButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        let containerStackView = UIStackView(arrangedSubviews: [iconImageView, labelStackView, actionButton])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.alignment = UIStackView.Alignment.fill
        containerStackView.axis = NSLayoutConstraint.Axis.vertical
        containerStackView.distribution = UIStackView.Distribution.fill
        containerStackView.spacing = 30.0
        
        addSubview(containerStackView)
        
        containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: 30.0).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -30.0).isActive = true
        containerStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor,
                                                constant: 8.0).isActive = true
        containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,
                                                   constant: -8.0).isActive = true
        containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    // MARK: - Actions
    
    @objc private func actionButtonTapped(_ button: UIButton) {
        delegate?.emptyStateViewActionButtonTapped(self)
    }
}

// MARK: - EmptyStateViewDelegate

protocol EmptyStateViewDelegate: class {
    func emptyStateViewActionButtonTapped(_ view: EmptyStateView)
}

