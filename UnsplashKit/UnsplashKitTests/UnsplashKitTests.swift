//
//  UnsplashKitTests.swift
//  UnsplashKitTests
//
//  Created by Yura Voevodin on 13.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import XCTest
@testable import UnsplashKit

class UnsplashKitTests: XCTestCase {
    
    override class func setUp() {
        // TODO: Add access key
        UnsplashKit.setup(accessKey: "")
    }

    func testPhotosRequest() {
        let exp = expectation(description: "Photos")
        UnsplashKit.APIClient.photos(page: 1) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
}
