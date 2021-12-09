//
//  RepositoriesViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import UIKit

class RepositoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet var numbersOfFilters: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterNames: UIView!
    @IBOutlet var textField: UITextField!

    var filterByName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig(numbersOfFilters: numbersOfFilters, filterNames: filterNames)
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self

        self.hideKeyboardWhenTappedAround()

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        let service = GithubService()

        service.searchRepositories(query: "A") { [weak self] result in
            switch result {
            case .success(let result):
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
                cell.setData(repository: result[indexPath.row])
            }

            if !indexPath.row.isMultiple(of: 2) {
                cell.invertTheme()
            } else {
                cell.mainTheme()
            }

            return cell
        }

        return UITableViewCell()
    }

    @IBAction func filterByNameChanged(_ sender: UITextField) {
        filterByName = sender.text
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let service = GithubService()
        service.searchRepositories(query: filterByName ?? "") { [weak self] result in
            switch result {
            case .success(let result):
                self?.result = result.items
                self?.tableView.reloadData()

            case .error(let message):
                let alert = UIAlertController(title: "Não foi possível realizar essa ação.", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self?.present(alert, animated: true)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let service = GithubService()
        service.searchRepositories(query: textField.text ?? "") { [weak self] result in
            switch result {
            case .success(let result):
                self?.result = result.items
                self?.tableView.reloadData()

            case .error(let message):
                let alert = UIAlertController(title: "Não foi possível realizar essa ação.", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self?.present(alert, animated: true)
            }
        }

        return true
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
