//
//  Product.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit

class MerchantList {
    var merchantName: String = "Unknown"
    var productList: [Product] = []

    init(merchantName: String = "Unknown", productList: [Product] = []) {
        self.merchantName = merchantName
        self.productList = productList
    }
}

class ProductList: Decodable {
    var posts: [Product]

    public func appendProduct(_ product: Product) {
        posts.append(product)
    }

    public func replacePosts(with newPosts: [Product]?) {
        guard let newPosts = newPosts else { return }
        posts = newPosts
    }

}

class Product: Decodable {

    let id: String
    let createdAt: String
    let updatedAt: String
    let title: String
    let images: [String]
    let url: String
    let merchant: String
}
