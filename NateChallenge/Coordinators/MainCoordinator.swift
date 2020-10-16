//
//  MainCoordinator.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit

final class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.barTintColor = .white
    }

    func start() {
        let dataSource = ProductListDataSource()
        let vc = HomeScreenViewController(coordinator: self, productListDataSource: dataSource)
        vc.title = "Home"
        navigationController.pushViewController(vc, animated: false)
    }

    func showProductDetails(for product: Product) {
        let vc = ProductDetailsViewController(coordinator: self, product: product)
        vc.title = "Product Details"
        navigationController.pushViewController(vc, animated: true)
    }

}
