//
//  APIRequest.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import Foundation

protocol APIRequest {
    func requestProductList(skip: Int, take: Int, completion: @escaping (Bool) -> Void)
}
