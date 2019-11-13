//
//  NetworkRequest.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

extension UnsplashKit {
    
    /// For subclassing
    open class NetworkRequest {
        
        // MARK: - Properties
        
        /// Base URL
        public var baseURLString: String {
            return baseURL
        }
        
        /// HTTP method
        open var method: String {
            return "GET"
        }
        
        /// Path for API endpoint
        open var path: String {
            return ""
        }
        
        // MARK: - Init
        
        public init() {
            
        }
        
        // MARK: - Methods
        
        /// Build URLComponents from `baseURLString`
        public func baseURLComponents() -> URLComponents {
            return URLComponents(string: baseURLString)!
        }
        
        /// Build an URLRequest
        public func buildURLRequest(items: [URLQueryItem]) -> URLRequest {
            // Request
            var urlComponents = baseURLComponents()
            urlComponents.queryItems = items
            let url = urlComponents.url?.appendingPathComponent(path)
            let urlRequest = URLRequest(url: url!)
            
            // Headers
            let configuredRequest = configure(urlRequest)
            
            return configuredRequest
        }
        
        /// Configure an URLRequest with headers
        public func configure(_ request: URLRequest) -> URLRequest {
            var urlRequest = request
            urlRequest.httpMethod = method
            
            // Headers
            urlRequest.setValue("v1", forHTTPHeaderField: "Accept-Version")
            urlRequest.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
            
            return urlRequest
        }
    }
}
