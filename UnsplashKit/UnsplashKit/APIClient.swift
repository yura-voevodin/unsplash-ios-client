//
//  APIClient.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

extension UnsplashKit {
    
    class APIClient {
        
        static func photos(page: Int, _ completion: @escaping ([String]) -> ()) {
            let request = Request(kind: .photos)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    completion([])
                } else {
                    
                }
            }
            dataTask.resume()
        }
    }
}
