//
//  ViewController.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 06/12/21.
//

import UIKit

class ViewController: UITableViewController {

    var result: [Repository]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        let service = GithubService()

        service.searchRepositories(query: "javascript") { [weak self] result in
            switch result {
            case .success(let result):
                debugPrint(result.items)
                self?.result = result.items
                self?.tableView.reloadData()

            case .error(let message):
                let alert = UIAlertController(title: "Não foi possível realizar essa ação.", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self?.present(alert, animated: true)
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return result?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryTableViewCell {
            if let result = result {
                cell.name.text = result[indexPath.row].name

            }
            return cell
        }

        return UITableViewCell()
    }
}
