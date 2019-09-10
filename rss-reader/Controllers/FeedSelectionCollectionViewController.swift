//
//  FeedSelectionCollectionViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class FeedSelectionCollectionViewController: BaseCollectionViewController {

    private let feeds = RSSFeed.getFeeds()

    private var actionButton: OverlayButton!

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        collectionViewLayout = FeedSelectionCollectionViewLayout()
        super.viewDidLoad()
        title = String.localize("feed_selection_navigation_title")

        collectionView.allowsMultipleSelection = true
        register(cell: FeedSelectionCollectionViewCell())

        actionButton = OverlayButton(type: UIButton.ButtonType.system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = UIFont.avenirNextBoldFont(withSize: 18.0)
        actionButton.setTitle(String.localize("continue"), for: UIControl.State.normal)
        actionButton.addTarget(self,
                               action: #selector(actionButtonTapped(_:)),
                               for: UIControl.Event.touchUpInside)

        view.addSubview(actionButton)

        actionButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: 30.0).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -30.0).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -12.0).isActive = true

        updateInterface()
    }

    // MARK: - Configure

    private func configure(FeedSelectionCollectionViewCell cell: FeedSelectionCollectionViewCell,
                           withIndexPath indexPath: IndexPath) {
        let feed = feeds[indexPath.item]

        cell.title = feed.name
    }

    // MARK: - Actions

    @objc private func actionButtonTapped(_ button: UIButton) {

    }

    // MARK: - Helpers

    private func updateInterface() {
        if let indexPaths = collectionView.indexPathsForSelectedItems,
            indexPaths.count > 0 {
            actionButton.isEnabled = true
        } else {
            actionButton.isEnabled = false
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FeedSelectionCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        updateInterface()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        updateInterface()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedSelectionCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedSelectionCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! FeedSelectionCollectionViewCell

        configure(FeedSelectionCollectionViewCell: cell, withIndexPath: indexPath)

        return cell
    }
}
