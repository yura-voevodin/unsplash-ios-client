//
//  ImageDownloader.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 14.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit

public extension UnsplashKit {
    
    class ImageDownloader {
        
        // MARK - Init
        
        public init() {}
        
        // MARK: - Setup
        
        public static func configureCache() {
            let cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
            URLCache.shared = cache
        }
        
        // MARK: - Download
        
        private var task: URLSessionDataTask?
        
        public func download(with url: URL, completion: @escaping (Result<UIImage?, Error>) -> ()) {
            // Do nothing if task is set and download in progress
            guard task == nil else {
                return
            }
            isCancelled = false
            
            let request = URLRequest(url: url)
            
            // Try to find image in cache
            if let cachedResponse = URLCache.shared.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
                completion(.success(image))
                return
            }
            
            task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                self?.task = nil
                
                guard let data = data, let response = response, let image = UIImage(data: data), error == nil else { return }
                
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            })
            task?.resume()
        }
        
        // MARK: - Cancel
        
        public private(set) var isCancelled = false
        
        public func calncel() {
            isCancelled = true
            task?.cancel()
        }
    }
}
