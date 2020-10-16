//
//  ProductListDataSource.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit
import CocoaLumberjack

final class ProductListDataSource: NSObject, UITableViewDataSource {

    private var productList: ProductList?
    private var latestUnfiltered: [Product] = []
    private let api = API()

}

// MARK: External Methods
extension ProductListDataSource {

    func loadProductBatch(skip: Int, take: Int, completion: @escaping (Bool) -> Void) {
        requestProductList(skip: skip, take: take) { success in
            completion(success)
        }
    }

    func filterProductsWith(text: String) {
        guard let list = productList?.posts else { return }

        let filteredList = list.filter {
            $0.merchant.lowercased().contains(text.lowercased()) ||
                $0.title.lowercased().contains(text.lowercased())
        }
        productList?.replacePosts(with: filteredList)
    }

    func unfilterProducts() {
        productList?.replacePosts(with: latestUnfiltered)
    }

    func getCurrentProductCount() -> Int {
        productList?.posts.count ?? 0
    }

    func clearProductsList() {
        productList = nil
        latestUnfiltered.removeAll()
    }

}

// MARK: Internal Methods
private extension ProductListDataSource {

    func decodeProductList(from data: Data) {
        do {
            let productBatch = try JSONDecoder().decode(ProductList.self, from: data)
            if productList == nil {
                productList = productBatch
            } else {
                productBatch.posts.forEach { product in
                    productList?.appendProduct(product)
                }
            }
            latestUnfiltered.removeAll()
            productList?.posts.forEach { product in
                latestUnfiltered.append(product)
            }
        } catch {
            DDLogError("\(URL(fileURLWithPath: #file).lastPathComponent):\(#function)=\(error)")
        }
    }

//    func createProductsByMerchant() {
//        guard let list = productList?.posts, let merchantNames = NSOrderedSet(array: list.map { $0.merchant }).array as? [String] else {
//                return
//            }
//
//        for merchant in merchantNames {
//            let innerArray = list.filter { $0.merchant == merchant }
//            sortedProductList.append(MerchantList(merchantName: merchant, productList: innerArray))
//           }
//        sortedProductList.sort { $0.merchantName < $1.merchantName }
//
//    }

}

// MARK: UITableView DataSource
extension ProductListDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList?.posts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell,
              let product = productList?.posts[indexPath.row] else { return UITableViewCell() }
        cell.setProduct(product)
        cell.setProductTitle(product.title)
        cell.setProductImage(withURL: product.images.first)
        return cell
    }

}

// MARK: API Protocol
extension ProductListDataSource: APIRequest {

    func requestProductList(skip: Int, take: Int, completion: @escaping (Bool) -> Void) {
        DDLogInfo("Datasource requestProductsList called")
        do {
            try api.requestProductsList(skip: skip, take: take) { result in
                switch result {
                case .success(let data):
                    self.decodeProductList(from: data)
                    completion(true)
                case .failure(let error):
                    DDLogError("\(URL(fileURLWithPath: #file).lastPathComponent):\(#function)=\(error)")
                    completion(false)
                }
            }
        } catch {
            DDLogError("\(URL(fileURLWithPath: #file).lastPathComponent):\(#function)=\(error)")
            completion(false)
        }
    }

}
