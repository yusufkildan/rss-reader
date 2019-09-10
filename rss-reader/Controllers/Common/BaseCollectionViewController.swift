//
//  BaseCollectionViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class BaseCollectionViewController: BaseViewController {
    var collectionViewLayout: UICollectionViewLayout!
    var collectionView: UICollectionView!

    private lazy var refreshControl: UIRefreshControl! = {
        [unowned self] in
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ColorPalette.Primary.tint
        return refreshControl
        }()

    var contentInset: UIEdgeInsets! {
        get {
            return collectionView.contentInset
        }

        set (newValue) {
            collectionView.contentInset = newValue
        }
    }

    var scrollIndicatorInsets: UIEdgeInsets! {
        didSet {
            collectionView.scrollIndicatorInsets = scrollIndicatorInsets
        }
    }

    var strictBackgroundColor: UIColor? {
        didSet {
            view.backgroundColor = strictBackgroundColor
            collectionView.backgroundColor = strictBackgroundColor
            subComponentsHolderView.backgroundColor = strictBackgroundColor
        }
    }

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.bringSubviewToFront(subComponentsHolderView)

        if canPullToRefresh() {
            refreshControl.addTarget(self,
                                     action: #selector(refresh(_:)),
                                     for: UIControl.Event.valueChanged)

            collectionView.refreshControl = refreshControl
        }

        strictBackgroundColor = ColorPalette.Primary.Light.background

        var insets = contentInset
        insets?.bottom += defaultBottomInset()

        contentInset = insets
    }

    // MARK: - Refresh

    func canPullToRefresh() -> Bool {
        return false
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {

    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    // MARK: - Notifications

    override func didReceiveKeyboardWillShowNotification(_ notification: Notification) {
        handleInsetsOf(ScrollView: collectionView,
                       forAction: KeyboardAction.show,
                       withNotification: notification)
    }

    override func didReceiveKeyboardWillHideNotification(_ notification: Notification) {
        handleInsetsOf(ScrollView: collectionView,
                       forAction: KeyboardAction.hide,
                       withNotification: notification)
    }

    // MARK: - Helper Methods

    func register<T: UICollectionViewCell>(cell: T) {
        collectionView.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(reusableView: T, kind: String) {
        collectionView.register(T.self, forSupplementaryViewOfKind: kind,
                                withReuseIdentifier: T.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDelegate

extension BaseCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: - UICollectionViewDataSource

extension BaseCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
