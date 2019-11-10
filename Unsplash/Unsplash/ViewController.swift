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
        requestPhotos()
    }
    
    // MARK: - Photos
    
    private func requestPhotos() {
        UnsplashKit.APIClient.photos(page: 1) { (photos) in
            DispatchQueue.main.async {
                print(photos)
            }
        }
    }
}

