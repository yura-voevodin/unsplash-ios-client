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
        // Setup
        UnsplashKit.setup(accessKey: "395000f31162ea8ce8d171ca3ab2368578273b0a88563867f9e36b5bdbaf4c8a")
        
        // Configure cache
        UnsplashKit.ImageDownloader.configureCache()
        
        // Search
        configureSearchResultsController()
        
        // Photos data source
        configurePhotosDataSource()
        
        // Collection
        configureCollectionView()
        configureDataSource()
        
        // Frist page
        photosDataSource.requestPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // We want ourselves to be the delegate for this collection view so didSelectRowAtIndexPath(_:) is called for both controllers.
        searchResultsViewController.collectionView.delegate = self
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "showPhoto":
            let vc = segue.destination as? PhotoViewController
            vc?.photo = sender as? Photo
            
        default:
            break
        }
    }
    
    // MARK: - Search
    
    var searchController: UISearchController!
    
    var searchResultsViewController: SearchResultsViewController!
    
    var searchDataSource: UnsplashKit.SearchDataSource {
        return searchResultsViewController.searchDataSource
    }
    
    /// Sear Bar and Search Results Controller
    private func configureSearchResultsController() {
        searchResultsViewController = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController
        
        // Setup the Search Controller.
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        
        // Add Search Controller to the navigation item.
        navigationItem.searchController = searchController
        
        // Setup the Search Bar
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "Placeholder in search controller")
        
        definesPresentationContext = true
        
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchResultsUpdater = self
        
        // Always visible search bar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Context menu
    
    func makeContextMenu(for photo: Photo) -> UIMenu {
        let delete = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.searchResultsViewController.delete(photo)
        }
        return UIMenu(title: "", children: [delete])
    }
}

// MARK: - PhotosDataSourceDelegate

extension ViewController: PhotosDataSourceDelegate {
    
    func didReceive(_ error: Error) {
        print(error)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let photo = photosDataSource.photos[indexPath.row]
            performSegue(withIdentifier: "showPhoto", sender: photo)

        } else if collectionView == searchResultsViewController.collectionView {
            // Search results
            let photo = searchDataSource.photos[indexPath.row]
            performSegue(withIdentifier: "showPhoto", sender: photo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard collectionView == searchResultsViewController.collectionView else {
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let photo = self.searchDataSource.photos[indexPath.row]
            return self.makeContextMenu(for: photo)
        })
    }
}

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            if photosDataSource.isFetching {
                return
            }
            let buffer: CGFloat = 55
            let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
            let scrollPosition = scrollView.contentOffset.y
            
            // Reached the bottom of the collection view
            if scrollPosition > bottom + buffer {
              photosDataSource.requestPhotos()
            }
            
        } else if searchResultsViewController.collectionView == scrollView {
            if searchDataSource.isFetching {
                return
            }
            let buffer: CGFloat = 55
            let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
            let scrollPosition = scrollView.contentOffset.y
            
            // Reached the bottom of the collection view
            if scrollPosition > bottom + buffer {
              searchDataSource.search()
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Strip out all the leading and trailing spaces.
        guard let text = searchController.searchBar.text else { return }
        let searchString = text.trimmingCharacters(in: .whitespaces)
        
        // Minimum 3 characters
        guard searchString.count >= 3 else {
            searchResultsViewController.resetSearchResults()
            return
        }
        
        // Perform search request
        searchResultsViewController.search(by: searchString)
    }
}
