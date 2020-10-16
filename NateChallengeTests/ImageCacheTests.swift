//
//  ImageCacheTests.swift
//  NateChallengeTests
//
//  Created by Stephen Sement on 15/10/2020.
//

import XCTest
@testable import NateChallenge

class ImageCacheTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStoringAndRetrievingInCache() throws {
        guard let image = UIImage(systemName: "pencil") else {
            XCTFail("Couldn't create image")
            return
        }
        ImageCache.shared.imageCache.setObject(image, forKey: "testCache")

        guard let cachedImage = ImageCache.shared.imageCache.object(forKey: "testCache") else {
            XCTFail("Couldn't retrieve image")
            return
        }
        if !cachedImage.isEqual(image) { XCTFail("Images are not equal") }
    }

}
