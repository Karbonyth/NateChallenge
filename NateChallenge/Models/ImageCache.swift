//
//  ImageCache.swift
//  NateChallenge
//
//  Created by Stephen Sement on 12/10/2020.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    let imageCache = NSCache<NSString, UIImage>()

    init() {}
}
