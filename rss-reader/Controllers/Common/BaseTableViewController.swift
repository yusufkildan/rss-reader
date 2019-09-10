//
//  BaseTableViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {

    var tableView = UITableView(frame: CGRect.zero)

    private lazy var refreshControl: UIRefreshControl! = {
        [unowned self] in
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ColorPalette.Primary.tint
        return refreshControl
        }()
    
    var contentInset: UIEdgeInsets! {
        get {
            return tableView.contentInset
        }

        set (newValue) {
            tableView.contentInset = newValue
        }
    }

    var scrollIndicatorInsets: UIEdgeInsets! {
        didSet {
            tableView.scrollIndicatorInsets = scrollIndicatorInsets
        }
    }

    var style = UITableView.Style.plain

    var strictBackgroundColor: UIColor? {
        didSet {
            view.backgroundColor = strictBackgroundColor
            tableView.backgroundColor = strictBackgroundColor
            subComponentsHolderView.backgroundColor = strictBackgroundColor
        }
    }

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect.zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear

        view.addSubview(tableView)

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        if canPullToRefresh() {
            refreshControl.addTarget(self,
                                     action: #selector(refresh(_:)),
                                     for: UIControl.Event.valueChanged)

            tableView.refreshControl = refreshControl
        }

        view.bringSubviewToFront(subComponentsHolderView)

        var insets = contentInset
        insets?.bottom += defaultBottomInset()

        contentInset = insets

        strictBackgroundColor = ColorPalette.Primary.Light.background
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
        handleInsetsOf(ScrollView: tableView,
                       forAction: KeyboardAction.show,
                       withNotification: notification)
    }

    override func didReceiveKeyboardWillHideNotification(_ notification: Notification) {
        handleInsetsOf(ScrollView: tableView,
                       forAction: KeyboardAction.hide,
                       withNotification: notification)
    }

    // MARK: - Helper Methods

    func register<T: UITableViewCell>(cell: T) {
        tableView.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterView: T) {
        tableView.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

// MARK: - UITableViewDelegate

extension BaseTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - UITableViewDataSource

extension BaseTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
