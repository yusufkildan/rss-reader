//
//  NewsListTableViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit
import Kingfisher

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

        feedItems = DataManager.getPersistedNews()
        let refresh = feedItems.count > 0
        loadData(withRefresh: refresh)
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
        if !refresh {
            super.loadData(withRefresh: refresh)
        }

        DataManager.fetchNews { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.feedItems = items
                self.updateControllerState(withState: ControllerState.none)
            case .failure(_):
                self.updateControllerState(withState: ControllerState.error)
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

        if let date = item.pubDate {
            cell.publishInfo = Date.timePassedSinceDate(date)
        } else {
            cell.publishInfo = "-"
        }

        if let mediaThumbnail = item.mediaThumbnail, let url = URL(string: mediaThumbnail) {
            cell.thumbnailImageView.kf.setImage(with: url)
        } else if let mediaContent = item.mediaContent, let url = URL(string: mediaContent) {
            cell.thumbnailImageView.kf.setImage(with: url)
        } else if let imagesFromContent = item.imagesFromContent, imagesFromContent.count > 0 {
            if let url = URL(string: imagesFromContent[0]) {
                cell.thumbnailImageView.kf.setImage(with: url)
            }
        } else if let imagesFromDescription = item.imagesFromDescription, imagesFromDescription.count > 0 {
            if let url = URL(string: imagesFromDescription[0]) {
                cell.thumbnailImageView.kf.setImage(with: url)
            }
        } else {
            cell.thumbnailImageView.image = UIImage(named: "defaultThumbnailImage")
        }

        cell.isReaded = item.isReaded
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

        let viewController = NewsDetailWebViewController(withItem: item)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
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
        loadData(withRefresh: false)
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

// MARK: - NewsDetailWebViewControllerDelegate

extension NewsListTableViewController: NewsDetailWebViewControllerDelegate {
    func newsDetailWebViewControllerDidReadArticle(_ viewController: NewsDetailWebViewController,
                                                   item: FeedItem) {
        if let index = items.firstIndex(of: item) {
            items[Int(index)].isReaded = true
            DataManager.marksAsAReaded(item)
            tableView.reloadData()
        }
    }
}
