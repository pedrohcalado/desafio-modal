//
//  MainCoordinator.swift
//  DesafioModal
//
//  Created by Pedro Henrique Calado on 06/12/21.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start() {
        self.navigationController.navigationBar.isHidden = true

        let coordinator = RepositoriesCoordinator()
        coordinator.navigationController = navigationController

        start(coordinator: coordinator)
    }
}
