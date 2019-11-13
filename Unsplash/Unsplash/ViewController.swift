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

    // MARK: - View life cycle

    override func viewDidLoad() {
      super.viewDidLoad()

      setup()
    }

    private func setup() {
        UnsplashKit.setup(accessKey: "")
        
        configureDataSource()
        requestPhotos()
    }
    
    // MARK: - Data Source
    
    var photosDataSource: UnsplashKit.PhotosDataSource!
    
    private func configureDataSource() {
        photosDataSource = UnsplashKit.PhotosDataSource()
        photosDataSource.delegate = self
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
    
    func didLoadPhotos() {
        
    }
}
