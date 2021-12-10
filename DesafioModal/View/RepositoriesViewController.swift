//
//  RepositoriesViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import RxCocoa
import RxSwift
import UIKit

class RepositoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet var numbersOfFilters: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterNames: UIView!

    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var filterButton: UIButton!

    @IBOutlet var clearFiltersButton: UIButton!

    private let disposeBag = DisposeBag()
    var viewModel: RepositoriesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBindings()

        roundTop(viewName: filterNames)
        roundCorners(numbersOfFilters: numbersOfFilters)
        bottomBlackline(viewName: filterNames)
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self

        self.hideKeyboardWhenTappedAround()

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryTableViewCell {

            cell.setData(repository: self.viewModel.repositories[indexPath.row])

            if !indexPath.row.isMultiple(of: 2) {
                cell.invertTheme()
            } else {
                cell.mainTheme()
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = self.viewModel.repositories[indexPath.row]
        self.viewModel.showDetailsOfRepository(repository)
    }

    private func setUpBindings() {
        searchTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in self?.viewModel.search() })
            .disposed(by: disposeBag)

        searchTextField.rx.text
            .orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .bind { [weak self] in self?.viewModel.search() }
            .disposed(by: disposeBag)

        viewModel.didSearchEnded
            .subscribe(onNext: { [weak self] in self?.tableView.reloadData() })
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .bind { [weak self] in self?.viewModel.showFilterSettings() }
            .disposed(by: disposeBag)

        clearFiltersButton.rx.tap
            .bind { [weak self] in self?.viewModel.clearFilters() }
            .disposed(by: disposeBag)
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
