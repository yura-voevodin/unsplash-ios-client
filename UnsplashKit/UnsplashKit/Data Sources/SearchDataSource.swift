//
//  SearchDataSource.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 17.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

public protocol SearchDataSourceDelegate: class {
    func didReceive(_ error: Error)
    func didLoadPhotos(_ newPhotos: [UnsplashKit.Photo])
}

public extension UnsplashKit {
    
    class SearchDataSource {
        
        public weak var delegate: PhotosDataSourceDelegate?
        private var canFetchMore = true
        private var currentPage: Int = 1
        public var isFetching = false
        public var photos: [Photo] = []
        public var query: String?
        
        // MARK: - Init
        
        public init() {}
        
        // MARK: - Search request
        
        public func search() {
            guard let query = query else {
                delegate?.didLoadPhotos([])
                return
            }
            guard canFetchMore else {
                delegate?.didLoadPhotos([])
                return
            }
            
            isFetching = true
            
            APIClient.search(query, page: currentPage) { (result) in
                DispatchQueue.main.async {
                    self.process(result)
                }
            }
        }
        
        private func process(_ result: Result<[Photo], Error>) {
            switch result {
                
            case .failure(let error):
                delegate?.didReceive(error)
                
            case .success(let newPhotos):
                if newPhotos.isEmpty {
                    canFetchMore = false
                } else {
                    photos.append(contentsOf: newPhotos)
                }
                currentPage += 1
                // Limit to 10 pages
                if currentPage >= 10 {
                    canFetchMore = false
                }
                delegate?.didLoadPhotos(newPhotos)
            }
            isFetching = false
        }
        
        public func resetSearch() {
            isFetching = false
            canFetchMore = true
            currentPage = 1
            photos = []
        }
    }
}
