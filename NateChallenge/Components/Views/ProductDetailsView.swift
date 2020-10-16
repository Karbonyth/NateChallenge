//
//  ProductDetailsView.swift
//  NateChallenge
//
//  Created by Stephen Sement on 12/10/2020.
//

import UIKit
import CocoaLumberjack

class ProductDetailsView: UIView {

    private var titleLabel = UILabel()
    private var descriptionTextView = UITextView()
    private var vendorLabel = UILabel()
    private var vendorNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: UI Setup
private extension ProductDetailsView {

    func setupViews() {
        configureSelf()
        configureTitleLabel()
        configureDescriptionTextView()
        configureVendorLabel()
        configureVendorNameLabel()

        layoutTitleLabel()
        layoutDescriptionTextView()
        layoutVendorLabel()
        layoutVendorNameLabel()
    }

    // MARK: Configurations
    func configureSelf() {
        backgroundColor = .white
    }

    func configureTitleLabel() {
        prepareSubviewsForAutolayout(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "{title}"
    }

    func configureDescriptionTextView() {
        prepareSubviewsForAutolayout(descriptionTextView)
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.isEditable = false
        descriptionTextView.text = "{description}"
    }

    func configureVendorLabel() {
        prepareSubviewsForAutolayout(vendorLabel)
        vendorLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        vendorLabel.text = "Sold by:"
    }

    func configureVendorNameLabel() {
        prepareSubviewsForAutolayout(vendorNameLabel)
        vendorNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        vendorNameLabel.text = "{vendor}"
    }

    // MARK: Layouts
    func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    func layoutDescriptionTextView() {
        NSLayoutConstraint.activate([
            descriptionTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: vendorLabel.topAnchor, constant: -16)
        ])
    }

    func layoutVendorLabel() {
        NSLayoutConstraint.activate([
            vendorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            vendorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    func layoutVendorNameLabel() {
        NSLayoutConstraint.activate([
            vendorNameLabel.centerYAnchor.constraint(equalTo: vendorLabel.centerYAnchor),
            vendorNameLabel.leadingAnchor.constraint(equalTo: vendorLabel.trailingAnchor, constant: 8)
        ])
    }

}

// MARK: External Methods
extension ProductDetailsView {

    func setProductTitle(with string: String?) {
        titleLabel.text = string
    }

    func setProductDescription(with string: String?) {
        descriptionTextView.text = string
    }

    func setProductVendor(with string: String?) {
        vendorNameLabel.text = string
    }

    func toggleEditMode() {
        DDLogInfo("\(URL(fileURLWithPath: #file).lastPathComponent):\(#function)= Method was not implemented")
    }

}
