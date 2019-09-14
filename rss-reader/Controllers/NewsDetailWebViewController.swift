//
//  NewsDetailWebViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailWebViewController: BaseWebViewController {

    private let url: URL

    private var backButton: OverlayButton!

    // MARK: - Constructors

    init(withURL url: URL) {
        self.url = url
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubviewToFront(subComponentsHolderView)
        updateControllerState(withState: ControllerState.loading)

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

        webView.load(URLRequest(url: url))
    }

    // MARK: - Interface

    override var shouldShowNavigationBar: Bool {
        return false
    }

    // MARK: - Actions

    @objc private func actionButtonTapped(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension NewsDetailWebViewController {
    override func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
        updateControllerState(withState: ControllerState.none)
    }

    override func webView(_ webView: WKWebView,
                          didFail navigation: WKNavigation!,
                          withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            guard let self = self else {
                return
            }
            self.webView.load(URLRequest(url: self.url))
        }
    }
}
