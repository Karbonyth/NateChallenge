//
//  ErrorView.swift
//  NateChallenge
//
//  Created by Stephen Sement on 11/10/2020.
//

import UIKit

class ErrorView: UIView {

    private var errorImage = UIImageView()
    private var errorLabel = UILabel()
    private var refreshButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: UI Setup
private extension ErrorView {

    func setupViews() {
        configureSelf()
        configureErrorImage()
        configureErrorLabel()
        configureRefreshButton()

        layoutErrorImage()
        layoutErrorLabel()
        layoutRefreshButton()
    }

    // MARK: Configurations
    func configureSelf() {
        backgroundColor = .white
    }

    func configureErrorImage() {
        prepareSubviewsForAutolayout(errorImage)
        errorImage.contentMode = .scaleAspectFit
        errorImage.image = UIImage(systemName: "xmark.octagon") ?? nil
    }

    func configureErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.text = "Network error, please refresh or try again later"
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    func configureRefreshButton() {
        prepareSubviewsForAutolayout(refreshButton)
        refreshButton.layer.cornerRadius = 4
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.backgroundColor = .systemBlue
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    // MARK: Layouts
    func layoutErrorImage() {
        prepareSubviewsForAutolayout(errorLabel)
        NSLayoutConstraint.activate([
            errorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImage.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -16),
            errorImage.heightAnchor.constraint(equalToConstant: 64),
            errorImage.widthAnchor.constraint(equalToConstant: 64)
        ])
    }

    func layoutErrorLabel() {
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
    }

    func layoutRefreshButton() {
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

}

// MARK: External Methods
extension ErrorView {

    func setRefreshButtonTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        refreshButton.addTarget(target, action: action, for: event)
    }

}
