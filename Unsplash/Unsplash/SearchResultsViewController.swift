//
//  SearchResultsViewController.swift
//  Unsplash
//
//  Created by Yura Voevodin on 17.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit
import UnsplashKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - Types
    
    typealias Photo = UnsplashKit.Photo
    
    enum Section {
        case main
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        // Search data source
        configurePhotosDataSource()
        
        // Collection
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Data Source
    
    var searchDataSource: UnsplashKit.SearchDataSource!
    
    private func configurePhotosDataSource() {
        searchDataSource = UnsplashKit.SearchDataSource()
        searchDataSource.delegate = self
    }
    
    // MARK: - Collection view
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Photo>! = nil
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(PhotoCollectionViewCell.self)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photo: Photo) -> UICollectionViewCell? in
            
            // Get a cell
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PhotoCollectionViewCell
            cell.update(with: photo)
            
            // Return the cell
            return cell
        }
        
        // initial data
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(searchDataSource.photos)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }

    // MARK: - Search
    
    func search(by query: String) {
        if query != searchDataSource.query {
            searchDataSource.resetSearch()
            searchDataSource.query = query
            searchDataSource.search()
        }
    }
    
    func resetSearchResults() {
        searchDataSource.resetSearch()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(searchDataSource.photos)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

// MARK: - PhotosDataSourceDelegate

extension SearchResultsViewController: PhotosDataSourceDelegate {
    
    func didReceive(_ error: Error) {
        print(error)
    }
    
    func didLoadPhotos(_ newPhotos: [UnsplashKit.Photo]) {
        if newPhotos.isEmpty == false {
            currentSnapshot.appendItems(newPhotos)
            dataSource.apply(currentSnapshot, animatingDifferences: true)
        }
    }
}
