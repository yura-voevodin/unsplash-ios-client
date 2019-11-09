//
//  UnsplashKit.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

/// Wrapper for this framework
struct UnsplashKit {
    
    static let baseURL = "https://api.unsplash.com/"
    
    // MARK: - Keys
    
    static private(set) var accessKey = ""
    
    static func setup(accessKey: String) {
        self.accessKey = accessKey
    }
}
