//
//  Coordinator.swift
//  DesafioModal
//
//  Created by Pedro Henrique Calado on 06/12/21.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
