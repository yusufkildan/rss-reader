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

    private lazy var searchBar: SearchBar = {
        let searchBar: SearchBar = SearchBar(frame: CGRect(x: 0.0, y: 16.0, width: Utils.screenWidth - 24.0, height: 60.0))
        searchBar.delegate = self
        return searchBar
    }()

    private var feedItems: [FeedItem] = []
    private var filteredItems: [FeedItem] = []
    private var isSearching = false

    private var items: [FeedItem] {
        if isSearching {
            return filteredItems
        } else {
            return feedItems
        }
    }

    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.localize("news_list_navigation_title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFeedButton)

        register(cell: NewsListTableViewCell())
        tableView.tableHeaderView = searchBar
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

        if refresh {
            feedItems = []
        }

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
        if indexPath.row >= items.count {
            return
        }

        let item = items[indexPath.row]
        if let title = item.title {
            cell.title = title
        } else {
            cell.title = "-"
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
        if indexPath.row >= items.count {
            return
        }

        let item = items[indexPath.row]

        if let link = item.link {
            let viewController = NewsDetailWebViewController(withURL: link)
            navigationController?.pushViewController(viewController, animated: true)
        }
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
        return items.count
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

// MARK: - UISearchBarDelegate

extension NewsListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filterNews(searchText)
        }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func filterNews(_ searchText: String) {
        filteredItems = feedItems.filter({ (item: FeedItem) -> Bool in
            if let title = item.title {
                let match = title.range(of: searchText,
                                        options: NSString.CompareOptions.caseInsensitive)
                return match != nil
            }

            return false
        })
    }
}
