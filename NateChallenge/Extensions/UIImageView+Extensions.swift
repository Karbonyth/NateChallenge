//
//  UIImageView+Extensions.swift
//  NateChallenge
//
//  Created by Stephen Sement on 11/10/2020.
//

import UIKit

extension UIImageView {

    func load(url: URL, completion: @escaping () -> Void) -> URLSessionDataTask? {

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    ImageCache.shared.imageCache.setObject((self?.image)!, forKey: url.absoluteString as NSString)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(named: "no-image")
                }
            }
            completion()
        })
    }

}
