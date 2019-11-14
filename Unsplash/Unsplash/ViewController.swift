//
//  ViewController.swift
//  Unsplash
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit
import UnsplashKit

class ViewController: UIViewController {
    
    typealias Photo = UnsplashKit.Photo
    
    enum Section {
        case main
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        // Setup
        UnsplashKit.setup(accessKey: "395000f31162ea8ce8d171ca3ab2368578273b0a88563867f9e36b5bdbaf4c8a")
        
        // Configure cache
        UnsplashKit.ImageDownloader.configureCache()
        
        // Photos data source
        configurePhotosDataSource()
        
        // Collection
        configureCollectionView()
        configureDataSource()
        
        // Frist page
        photosDataSource.requestNextPage()
    }
    
    // MARK: - Data Source
    
    var photosDataSource: UnsplashKit.PhotosDataSource!
    
    private func configurePhotosDataSource() {
        photosDataSource = UnsplashKit.PhotosDataSource()
        photosDataSource.delegate = self
    }
    
    // MARK: - Collection view
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>! = nil
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(PhotoCollectionViewCell.self)
        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.33))
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photosDataSource.photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Photos
    
    private func requestPhotos() {
        photosDataSource.requestNextPage()
    }
}

// MARK: - PhotosDataSourceDelegate

extension ViewController: PhotosDataSourceDelegate {
    
    func didReceive(_ error: Error) {
        
    }
    
    func didLoadPhotos(_ newPhotos: [UnsplashKit.Photo]) {
        if newPhotos.isEmpty == false {
            var snapshot = dataSource.snapshot()
            snapshot.appendItems(newPhotos)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photosDataSource.photos.count - 10 {
            photosDataSource.requestNextPage()
        }
    }
}
