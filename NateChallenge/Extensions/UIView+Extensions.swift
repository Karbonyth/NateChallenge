//
//  UIView+Extensions.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit

// MARK: Layout
extension UIView {

    func prepareSubviewsForAutolayout(_ subviews: UIView...) {
        prepareSubviewsForAutolayout(subviews)
    }

    func prepareSubviewsForAutolayout(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func applyFullConstraints(to views: UIView..., withSafeAreas: Bool = false, withInset: CGFloat = .zero) {
        applyFullConstraints(to: views, withSafeAreas: withSafeAreas, withInset: withInset)
    }

    func applyFullConstraints(to views: [UIView], withSafeAreas: Bool, withInset: CGFloat) {
        views.forEach {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.topAnchor : topAnchor, constant: withInset),
                $0.bottomAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor, constant: -withInset),
                $0.leadingAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor, constant: withInset),
                $0.trailingAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor, constant: -withInset)
            ])
        }
    }

}
