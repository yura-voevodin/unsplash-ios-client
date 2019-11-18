//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by Yura Voevodin on 16.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UnsplashKit
import UIKit

class PhotoViewController: UIViewController {
    
    var photo: UnsplashKit.Photo?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        activityIndicator.startAnimating()
        
        if let photo = photo, let url = photo.urls[.regular] {
            downloader.download(with: url) { [weak self] (result) in
                self?.process(result)
            }
        } else {
            imageView.image = nil
        }
    }
    
    private func process(_ result: Result<UIImage?, Error>) {
        activityIndicator.stopAnimating()
        switch result {
        case .failure:
            imageView.image = nil
        case .success(let image):
            imageView.image = image
        }
    }
    
    // MARK: - Image
    
    @IBOutlet weak var imageView: UIImageView!
    private var downloader = UnsplashKit.ImageDownloader()
    
    // MARK: - Activity
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
