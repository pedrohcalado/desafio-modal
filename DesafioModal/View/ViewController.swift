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
        
        let service = GithubService()

        service.searchRepositories(query: "javascript") { [weak self] result in
            switch result {
            case .success(let result):
                debugPrint(result)

            case .error(let message):
                let alert = UIAlertController(title: "Não foi possível realizar essa ação.", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self?.present(alert, animated: true)
            }
        }

    }

}
