![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

## Foundation
- *Сleanness* 💎     - Project is built using SOLID principles.
- *Stability* ✊     - No memory leaks, thread safe, no crash 
- *Reuse* 🤹‍        - UI is implemented programmatically too. No Storyboard or Xibs.

## Overview
Simple RSS Reader app.
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/1MtNPA4Qels/0.jpg)](https://www.youtube.com/watch?v=1MtNPA4Qels)

## Expected
- [x] Select multiple RSS feeds & persist.
- [x] If the user already has a selection, don't show the RSS selection screen on app launch.
- [x] Fetch articles from the selected feeds, and persist them.
- [x] Show the articles in reverse chronological order.
- [x] When user clicks an article from the list, show the news article in an in-app browser
- [x] Pull to refresh mechanism

## Bonus
- [x] Add a feature to fade articles once they are read.
- [x] Add a searchbar to the News List Screen. User should be able to filter articles by title.

## Requirements
* iOS 11.0+
* Xcode 10.0+
* Swift 5.0+

## Technical Choices
- *No Storyboards or Xibs* - UI is implemented programatically. I'dont like storyboards beause of some disadventages. Disadventages:  not reusable, merge conflicts are difficult, slow, tricky code reviews etc.
- *All data persisted at documents directory* - There can be many solutions for caching in iOS platforms, like SQLite, CoreData or Realm, or other 3rd libraries. But I deciced to store my data as a JSON data at documentDirectory. I think it is more easier way to handle cache data, there is no need to add SQLite for small projects. To encode / decode my classes I've used Codable protocol.
- *Kingfisher* - I've used Kingfisher pod to download & cache images. https://github.com/onevcat/Kingfisher
- *MVC Architecture* 

## Feedback
If you have any questions or suggestions, feel free to open issue just at this project.

## References
- https://github.com/nmdias/FeedKit
- https://developer.apple.com/documentation/foundation/xmlparser
- https://medium.com/@MedvedevTheDev/xmlparser-working-with-rss-feeds-in-swift-86224fc507dc
