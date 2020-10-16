//
//  ProductTests.swift
//  NateChallengeTests
//
//  Created by Stephen Sement on 13/10/2020.
//

import XCTest
@testable import NateChallenge

class ProductTests: XCTestCase {

    private let bundle = Bundle.main

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
        Testing if the ProductList object can be properly created from a JSON
     */
    func testProductList() throws {
        guard let url = bundle.url(forResource: "mock", withExtension: "json") else {
            return
        }
        let productList = try JSONDecoder().decode(ProductList.self, from: Data(contentsOf: url))
        XCTAssertEqual(productList.posts.first?.title, "test item 1")
        XCTAssertEqual(productList.posts.last?.title, "test item 2")
    }

    /**
        Testing if the PageOffsetItem object can be encoded
     */
    func testRequestBody() throws {

        let body = PageOffsetItem(skip: 0, take: 100)
        _ = try JSONEncoder().encode(body)

    }

}
