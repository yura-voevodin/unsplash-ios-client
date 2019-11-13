//
//  KeyedDecodingContainer.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 13.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    typealias URLKind = UnsplashKit.Photo.URLKind
    
    func decode(_ type: [URLKind: URL].Type, forKey key: Key) throws -> [URLKind: URL] {
        let json = try self.decode([String: String].self, forKey: key)
        var urls: [URLKind: URL] = [:]
        for (key, value) in json {
            if let kind = URLKind(rawValue: key),
                let url = URL(string: value) {
                urls[kind] = url
            }
        }
        return urls
    }
}
