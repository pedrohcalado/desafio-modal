//
//  ViewController.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 06/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        let queque = "java"
        GithubService.shared.getRepositories(query: queque) { response in
            debugPrint(response)
        }

    }

}
