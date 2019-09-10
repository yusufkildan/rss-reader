//
//  NewsListTableViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class NewsListTableViewController: BaseTableViewController {

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.localize("news_list_navigation_title")
    }
}

