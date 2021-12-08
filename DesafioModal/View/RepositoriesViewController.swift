//
//  RepositoriesViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import UIKit

class RepositoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var numbersOfFilters: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterNames: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig(numbersOfFilters: numbersOfFilters, filterNames: filterNames)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        let service = GithubService()

        service.searchRepositories(query: "F") { [weak self] result in
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

    var result: [Repository]?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryTableViewCell {
            if let result = result {
                cell.setData(repo: result[indexPath.row])
                if !indexPath.row.isMultiple(of: 2) {
                    cell.invertTheme()
                }
            }
            return cell
        }

        return UITableViewCell()
    }

}
