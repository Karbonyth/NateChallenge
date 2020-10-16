//
//  Coordinator.swift
//  NateChallenge
//
//  Created by Stephen Sement on 10/10/2020.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
