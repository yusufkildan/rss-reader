//
//  BaseWebViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {

    var webView: WKWebView!

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.Primary.Light.background

        webView = WKWebView()
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = ColorPalette.Primary.Light.background
        webView.navigationDelegate = self

        view.addSubview(webView)

        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - WKNavigationDelegate

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {

    }
}
