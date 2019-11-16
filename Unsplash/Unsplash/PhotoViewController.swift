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
        if let photo = photo, let url = photo.urls[.regular] {
            downloader.download(with: url) { [weak self] (result) in
                switch result {
                case .failure:
                    self?.imageView.image = nil
                case .success(let image):
                    self?.imageView.image = image
                }
            }
        } else {
            imageView.image = nil
        }
    }

    // MARK: - Image
    
    @IBOutlet weak var imageView: UIImageView!
    private var downloader = UnsplashKit.ImageDownloader()
}
