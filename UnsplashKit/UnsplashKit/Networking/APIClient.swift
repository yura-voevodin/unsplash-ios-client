//
//  APIClient.swift
//  UnsplashKit
//
//  Created by Yura Voevodin on 09.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import Foundation

public extension UnsplashKit {
    
    class APIClient {
        
        public static func photos(page: Int, _ completion: @escaping (Result<[Photo], Error>) -> ()) {
            let networkRequest = Request(kind: .photos)
            var queryItems: [URLQueryItem] = []
            
            // Items per page
            queryItems.append(URLQueryItem(name: "per_page", value: "30"))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            
            let request = networkRequest.buildURLRequest(items: queryItems)
            
            print("""
                \(request)
                """)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion(.success(photos))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
        
        public static func search(_ query: String, page: Int, _ completion: @escaping (Result<[Photo], Error>) -> ()) {
            let networkRequest = Request(kind: .search)
            var queryItems: [URLQueryItem] = []
            
            // Parameters
            queryItems.append(URLQueryItem(name: "query", value: "\(query)"))
            queryItems.append(URLQueryItem(name: "per_page", value: "30"))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            
            let request = networkRequest.buildURLRequest(items: queryItems)
            
            print("""
                \(request)
                """)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let resultsJson = json as? [String: Any], let results = resultsJson["results"] as? [Any] else {
                            completion(.success([]))
                            return
                        }
                        let data = try JSONSerialization.data(withJSONObject: results, options: [])
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion(.success(photos))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
