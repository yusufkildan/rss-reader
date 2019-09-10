//
//  BaseWebViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class BaseWebViewController: BaseViewController {

    var webView: UIWebView!

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.Primary.Light.background

        webView = UIWebView()
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = ColorPalette.Primary.Light.background

        view.addSubview(webView)

        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

