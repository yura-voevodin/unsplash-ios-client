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
            case search
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
            case .search:
                return "/search/photos"
            }
        }
        
        // MARK: - Init
        
        public var kind: Kind
        
        public init(kind: Kind) {
            self.kind = kind
        }
    }
}
