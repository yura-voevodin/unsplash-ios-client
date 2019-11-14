//
//  PhotosDataSource.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 13.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

public protocol PhotosDataSourceDelegate: class {
    func didReceive(_ error: Error)
    func didLoadPhotos(_ newPhotos: [UnsplashKit.Photo])
}

public extension UnsplashKit {

    class PhotosDataSource {
        
        public weak var delegate: PhotosDataSourceDelegate?
        private var canFetchMore = true
        private var currentPage: Int = 1
        public var photos: [Photo] = []
        
        // MARK: - Init
        
        public init() {}
        
        // MARK: - Request page
        
        public func requestNextPage() {
            guard canFetchMore else {
                delegate?.didLoadPhotos([])
                return
            }
            APIClient.photos(page: currentPage) { (result) in
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
        }
    }
}
