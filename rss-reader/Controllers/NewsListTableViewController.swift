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

    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.localize("news_list_navigation_title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFeedButton)

        register(cell: NewsListTableViewCell())
    }

    // MARK: - Configure

    private func configure(NewsListTableViewCell cell: NewsListTableViewCell,
                           withIndexPath indexPath: IndexPath) {
        // TODO: - Remove Dummy Data
        cell.title = "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Sed posuere consectetur est at lobortis."
        cell.publishInfo = "Porta Vulputate Cras"
    }

    // MARK: - Actions

    @objc private func addFeedButtonTapped(_ button: UIButton) {
        // TODO: - Create Coordinator
        let viewController = FeedSelectionCollectionViewController()
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! NewsListTableViewCell
        
        configure(NewsListTableViewCell: cell, withIndexPath: indexPath)

        return cell
    }
}
