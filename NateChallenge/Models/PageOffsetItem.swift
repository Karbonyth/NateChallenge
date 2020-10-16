//
//  PageOffsetItem.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import Foundation

class PageOffsetItem: Codable {

    let skip: Int
    let take: Int

    init(skip: Int, take: Int) {
        self.skip = skip
        self.take = take
    }
}
