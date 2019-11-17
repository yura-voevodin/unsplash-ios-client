//
//  Photo.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 10.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

extension UnsplashKit {
    
    public struct Photo: Codable, Hashable {
        
        // MARK: - Types
        
        public enum URLKind: String, Codable {
            case regular
            case small
        }
        
        // MARK: - Properties
        
        public let id = UUID().uuidString
        public let urls: [URLKind: URL]
        
        // MARK: - Decode
        
        enum CodingKeys: String, CodingKey {
            case urls
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            urls = try container.decode([URLKind: URL].self, forKey: .urls)
        }
    }
}
