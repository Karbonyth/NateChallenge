//
//  API.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import Foundation
import CocoaLumberjack

final class API {

    private enum APIRoutes: String {
        case requestProducts = "/products/offset"
        case createProduct = "/product/create"
        case updateProduct = "/product/update"
        case deleteProduct = "/product/delete"
    }

    private let APIUrl = "http://localhost:3000"

    func requestProductsList(skip: Int, take: Int, completion: @escaping (Result<Data, Error>) -> Void) throws {

        let urlString = APIUrl + APIRoutes.requestProducts.rawValue
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(PageOffsetItem(skip: skip, take: take))

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }

        task.resume()
    }

}
