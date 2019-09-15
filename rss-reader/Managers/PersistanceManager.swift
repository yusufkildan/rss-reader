//
//  PersistanceManager.swift
//  rss-reader
//
//  Created by yusuf_kildan on 11.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import Foundation

enum File {
    case feeds
    case latestNews
    case readedNews

    var fileName: String {
        switch self {
        case .feeds:
            return "feeds"
        case .latestNews:
            return "latestNews"
        case .readedNews:
            return "readedNews"
        }
    }
}

class PersistanceManager {

    // MARK: - Constructors
    
    private init() {
        
    }
    
    // MARK: - Methods

    /// Returns documentDirectory url
    class func getURL() -> URL {
        let documentDirectory: FileManager.SearchPathDirectory = .documentDirectory
        
        if let url = FileManager.default.urls(for: documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL!")
        }
    }

    /// Persists encodable class/struct to <Application_Home>/DocumentsDirectory as JSON data
    ///
    /// - Parameters:
    ///   - object: the Encodable class/struct to store
    ///   - file: file location name to store the data
    /// - Throws: Error if there were any issues encoding the struct or writing it to disk
    class func persist<T: Encodable>(_ object: T, as file: File) {
        let url = getURL().appendingPathComponent(file.fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path,
                                           contents: data,
                                           attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Retrieve and decode a class/struct from a file on documentDirectory
    ///
    /// - Parameters:
    ///   - file: file name of the file holding desired data
    ///   - type: type (i.e. RSSFeed.self or [FeedItem].self)
    /// - Returns: decoded data
    class func retrieve<T: Decodable>(_ file: File, as type: T.Type) -> T {
        let url = getURL().appendingPathComponent(file.fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data not found at \(url.path)!")
        }
    }

    /// Returns File exists or not
    class func fileExists(_ file: File) -> Bool {
        let url = getURL().appendingPathComponent(file.fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }

    /// Removes the files at documentDirectory
    class func clear() {
        let url = getURL()
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
