//
//  NewsDetailWebViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit
import WebKit

protocol NewsDetailWebViewControllerDelegate: class {
    func newsDetailWebViewControllerDidReadArticle(_ viewController: NewsDetailWebViewController, item: FeedItem)
}

class NewsDetailWebViewController: BaseWebViewController {

    private let item: FeedItem

    private var backButton: OverlayButton!
    private var progressView: UIProgressView!

    private var progressObserver: NSKeyValueObservation?

    weak var delegate: NewsDetailWebViewControllerDelegate?

    // MARK: - Constructors

    init(withItem item: FeedItem) {
        self.item = item
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = ColorPalette.Secondary.tint

        view.addSubview(progressView)

        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        backButton = OverlayButton(type: UIButton.ButtonType.system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel?.font = UIFont.avenirNextBoldFont(withSize: 18.0)
        backButton.setTitle(String.localize("back"), for: UIControl.State.normal)
        backButton.addTarget(self,
                             action: #selector(actionButtonTapped(_:)),
                             for: UIControl.Event.touchUpInside)

        view.addSubview(backButton)

        let insets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 13.0, right: 30.0)
        backButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: insets.left).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -insets.right).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: -insets.bottom).isActive = true

        progressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self](webView, _) in
            guard let self = self else {
                return
            }

            self.progressView.progress = Float(webView.estimatedProgress)
        }

        loadWebsite()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        delegate?.newsDetailWebViewControllerDidReadArticle(self, item: item)
    }

    // MARK: - Interface

    override var shouldShowNavigationBar: Bool {
        return false
    }

    // MARK: - Actions

    @objc private func actionButtonTapped(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Other Methods

    private func loadWebsite() {
        if let url = item.link {
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - WKNavigationDelegate

extension NewsDetailWebViewController {
    override func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    override func webView(_ webView: WKWebView,
                          didFail navigation: WKNavigation!,
                          withError error: Error) {
        // If request fails try again 1 second later
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            guard let self = self else {
                return
            }
            self.loadWebsite()
        }
    }
}
