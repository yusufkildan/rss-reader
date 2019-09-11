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

    var fileName: String {
        switch self {
        case .feeds:
            return "feeds"
        case .latestNews:
            return "latestNews"
        }
    }
}

class PersistanceManager {
    
    // MARK: - Constructors
    
    private init() {
        
    }
    
    // MARK: - Methods
    
    class func getURL() -> URL {
        let documentDirectory: FileManager.SearchPathDirectory = .documentDirectory
        
        if let url = FileManager.default.urls(for: documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL!")
        }
    }
    
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
    
    class func fileExists(_ file: File) -> Bool {
        let url = getURL().appendingPathComponent(file.fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
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
