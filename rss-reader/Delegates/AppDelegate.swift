//
//  AppDelegate.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let rootViewController: BaseNavigationController
        if UserDefaultsManager.hasSelectedFeed {
            rootViewController = BaseNavigationController(rootViewController: NewsListTableViewController())
        } else {
            rootViewController = BaseNavigationController(rootViewController: FeedSelectionCollectionViewController())
        }

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        return true
    }
}

