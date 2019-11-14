//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by Yura Voevodin on 13.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit
import UnsplashKit

class PhotoCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableView {
    
    // MARK: - Life cicle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    // MARK: - Image
    
    @IBOutlet weak var imageView: UIImageView!
    private var downloader = UnsplashKit.ImageDownloader()
    
    // MARK: - Update
    
    func update(with photo: UnsplashKit.Photo) {
        if let url = photo.urls[.regular] {
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
}
