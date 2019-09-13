//
//  SearchBar.swift
//  rss-reader
//
//  Created by yusuf_kildan on 13.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        searchBarStyle = UISearchBar.Style.minimal
        backgroundColor = ColorPalette.Primary.Light.background
        tintColor = ColorPalette.Primary.tint
        placeholder = String.localize("search")
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = ColorPalette.Primary.Dark.text
        textFieldInsideSearchBar?.font = UIFont.avenirNextRegularFont(withSize: 16.0)

        let textFieldPlaceholderLabel = textFieldInsideSearchBar?.value(forKey: "placeholderLabel") as? UILabel
        textFieldPlaceholderLabel?.textColor = ColorPalette.Primary.Dark.text
        textFieldPlaceholderLabel?.font = UIFont.avenirNextRegularFont(withSize: 16.0)
    }
}
