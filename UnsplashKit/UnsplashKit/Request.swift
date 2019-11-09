//
//  Request.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

extension UnsplashKit.APIClient {
    
    class Request: UnsplashKit.NetworkRequest {
        
        public enum Kind {
            case photos
            case search(query: String)
        }
        
        override var method: String {
            switch kind {
            case .photos:
                return "GET"
            case .search:
                return "GET"
            }
        }
        
        override var path: String {
            switch kind {
            case .photos:
                return "/photos"
            case .search(let query):
                return "/search/photos?query=\(query)"
            }
        }
        
        // MARK: - Init
        
        public var kind: Kind
        
        public init(kind: Kind) {
            self.kind = kind
        }
    }
}
