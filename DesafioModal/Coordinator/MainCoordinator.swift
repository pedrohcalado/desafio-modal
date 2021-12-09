//
//  MainCoordinator.swift
//  DesafioModal
//
//  Created by Pedro Henrique Calado on 06/12/21.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    var viewController = DetailViewController()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
