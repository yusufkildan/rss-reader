//
//  NewsListTableViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class NewsListTableViewController: BaseTableViewController {

    private lazy var addFeedButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.setImage(UIImage(named: "addIcon"), for: UIControl.State.normal)
        button.addTarget(self,
                         action: #selector(addFeedButtonTapped(_:)),
                         for: UIControl.Event.touchUpInside)
        return button
    }()

    private var feedItems: [FeeedItem] = []

    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.localize("news_list_navigation_title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFeedButton)

        register(cell: NewsListTableViewCell())
        loadData(withRefresh: true)
    }

    // MARK: - Interface

    override func canPullToRefresh() -> Bool {
        return true
    }

    // MARK: - Refresh

    override func refresh(_ refreshControl: UIRefreshControl) {
        loadData(withRefresh: true)
    }
    
    // MARK: - Load Data

    override func loadData(withRefresh refresh: Bool) {
        super.loadData(withRefresh: refresh)
        let selectedFeeds = PersistanceManager.retrieve(File.feeds, as: [RSSFeed].self).filter { $0.isSelected }
        let dispatchGroup = DispatchGroup()

        var errorOccured = false

        selectedFeeds.forEach {
            let parser = RSSParser()
            let request = URLRequest(url: URL(string: $0.url)!)
            dispatchGroup.enter()
            parser.parseFor(request: request) { (feedInfo, error) in
                if let feedInfo = feedInfo {
                    self.feedItems += feedInfo.items
                } else if let _ = error {
                    errorOccured = true
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            if errorOccured {
                self.updateControllerState(withState: ControllerState.error)
            } else {
                self.updateControllerState(withState: ControllerState.none)
            }

            self.endRefreshing()
            self.tableView.reloadData()
        }
    }

    // MARK: - Configure

    private func configure(NewsListTableViewCell cell: NewsListTableViewCell,
                           withIndexPath indexPath: IndexPath) {
        if indexPath.row >= feedItems.count {
            return
        }

        let item = feedItems[indexPath.row]
        if let title = item.title {
            cell.title = title
        } else {
            cell.title = "-"
        }

        if let x = item.content {
            cell.publishInfo = x
        }
    }

    // MARK: - Actions

    @objc private func addFeedButtonTapped(_ button: UIButton) {
        // TODO: - Create Coordinator
        let viewController = FeedSelectionCollectionViewController()
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension NewsListTableViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
    }

    @objc func tableView(_ tableView: UITableView,
                         heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func tableView(_ tableView: UITableView,
                         estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

// MARK: - UITableViewDataSource

extension NewsListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! NewsListTableViewCell
        
        configure(NewsListTableViewCell: cell, withIndexPath: indexPath)

        return cell
    }
}

// MARK: - FeedSelectionCollectionViewControllerDelegate

extension NewsListTableViewController: FeedSelectionCollectionViewControllerDelegate {
    func feedSelectionCollectionViewControllerDidSelectFeeds(_ viewController: FeedSelectionCollectionViewController) {
        loadData(withRefresh: true)
    }
}
