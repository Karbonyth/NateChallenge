//
//  ProductCell.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit
import CocoaLumberjack

final class ProductCell: UITableViewCell {

    private var sessionDataTask: URLSessionDataTask?
    private weak var product: Product? //{
//        didSet {
//            setProductTitle(product?.title ?? "")
//            setProductImage(withURL: product?.images.first)
//        }
//    }
    private var productTitle = UILabel()
    private var productImage = UIImageView()
    private let loading = UIActivityIndicatorView(style: .medium)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        sessionDataTask?.cancel()
        product = nil
        productTitle.text = ""
        productImage.image = nil
        loading.stopAnimating()
    }

}

// MARK: UI Setup
private extension ProductCell {

    func setupViews() {
        configureSelf()
        configureLoadingIndicator()
        configureProductImage()
        configureProductTitle()

        layoutLoadingIndicator()
        layoutProductImage()
        layoutProductTitle()
    }

    // MARK: Configurations
    func configureSelf() {
        selectionStyle = .none
    }

    func configureLoadingIndicator() {
        productImage.prepareSubviewsForAutolayout(loading)
    }

    func configureProductTitle() {
        productTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productTitle.numberOfLines = 0
    }

    func configureProductImage() {
        productImage.contentMode = .scaleAspectFit
        productImage.layer.cornerRadius = 8
        productImage.layer.masksToBounds = true
    }

    // MARK: Layouts
    func layoutLoadingIndicator() {
        productImage.applyFullConstraints(to: loading)
    }

    func layoutProductTitle() {
        prepareSubviewsForAutolayout(productTitle)
        NSLayoutConstraint.activate([
            productTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            productTitle.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 16),
            productTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            productTitle.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            productTitle.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            topAnchor.constraint(lessThanOrEqualTo: productTitle.topAnchor, constant: -8),
            bottomAnchor.constraint(greaterThanOrEqualTo: productTitle.bottomAnchor, constant: 8)
        ])
    }

    func layoutProductImage() {
        prepareSubviewsForAutolayout(productImage)
        NSLayoutConstraint.activate([
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImage.widthAnchor.constraint(equalToConstant: 64),
            productImage.heightAnchor.constraint(equalToConstant: 64),
            topAnchor.constraint(lessThanOrEqualTo: productImage.topAnchor, constant: -8),
            bottomAnchor.constraint(greaterThanOrEqualTo: productImage.bottomAnchor, constant: 8)
        ])
    }
}

// MARK: Internal Methods
extension ProductCell {

    func setProductTitle(_ name: String) {
        productTitle.text = name
    }

    func setProductImage(withURL url: String?) {
        guard let url = url, !url.isEmpty else {
            productImage.image = UIImage(named: "no-image")
            return
        }

        productImage.image = nil
        if let cachedVersion = ImageCache.shared.imageCache.object(forKey: url as NSString) {
            productImage.image = cachedVersion
        } else {
            if let url = URL(string: url) {
                loading.startAnimating()
                DispatchQueue.global().async { [weak self] in
                    self?.sessionDataTask = self?.productImage.load(url: url) {
                        DispatchQueue.main.async {
                            self?.loading.stopAnimating()
                        }
                    }
                    self?.sessionDataTask?.resume()
                }
            } else { return }
        }
    }

}

// MARK: External Methods
extension ProductCell {

    func setProduct(_ product: Product) {
        self.product = product
    }

    func getProduct() -> Product? {
        self.product
    }

}
