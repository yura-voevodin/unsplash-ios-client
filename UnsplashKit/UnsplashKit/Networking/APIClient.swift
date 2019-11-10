//
//  APIClient.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

public extension UnsplashKit {
    
    public class APIClient {
        
        public static func photos(page: Int, _ completion: @escaping ([Photo]) -> ()) {
            let request = Request(kind: .photos)
            
            let dataTask = URLSession.shared.dataTask(with: request.buildURLRequest()) { (data, response, error) in
                if let _ = error {
                    completion([])
                } else if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(jsonObject)
                        debugPrint(jsonObject)
//                        let json = jsonObject as! [String: Any]
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion(photos)
                    } catch {
                        completion([])
                    }
                }
            }
            dataTask.resume()
        }
    }
}
