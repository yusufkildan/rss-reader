//
//  UserDefaultsManager.swift
//  rss-reader
//
//  Created by yusuf_kildan on 11.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    case hasSelectedFeed = "kHasSelectedFeed"
}

protocol KeyValueStorage {
    static func set(_ value: Any?, forKey key: String)
    static func get(_ key: String) -> Any?
    static func getAllKeys() -> [String]
}

class UserDefaultsManager: KeyValueStorage {
    // MARK:  - Methods

    static func set(_ value: Any?, forKey key: String) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        }
        else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }

    static func get(_ key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }

    static func getAllKeys() -> [String] {
        return Array(UserDefaults.standard.dictionaryRepresentation().keys)
    }

    // MARK: - Properties

    static var hasSelectedFeed: Bool {
        get {
            return (UserDefaultsManager.get(UserDefaultKeys.hasSelectedFeed.rawValue) as? Bool) ?? false
        } set(newValue) {
            UserDefaultsManager.set(newValue, forKey: UserDefaultKeys.hasSelectedFeed.rawValue)
        }
    }

}
