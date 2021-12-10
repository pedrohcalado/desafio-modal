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

    @IBOutlet var filterSortButton: UIButton!
    @IBOutlet var filterOrderButton: UIButton!

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

        try? applyStylingToButtons()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryTableViewCell {
            cell.setData(repository: self.viewModel.repositories[indexPath.row])
            indexPath.row.isMultiple(of: 2) ? cell.mainTheme() : cell.invertTheme()
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = self.viewModel.repositories[indexPath.row]
        self.viewModel.showDetailsOfRepository(repository)
    }

    private func applyStylingToButtons() throws {
        let buttons: [UIButton] = [filterSortButton, filterOrderButton]

        let labels = ["stars": "ESTRELAS", "forks": "SEGUIDORES", "updated": "DATA", "none": "", "asc": "CRESCENTE", "desc": "DECRESCENTE"]

        filterSortButton.isHidden = viewModel.filterService.sorting == nil

        filterSortButton.setTitle(labels[viewModel.filterService.sorting?.rawValue ?? "none"], for: .normal)
        filterOrderButton.setTitle(labels[viewModel.filterService.order.rawValue], for: .normal)

        for button in buttons {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)

            button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

            let xMark = UIImage.init(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .light))

            button.setImage(xMark, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8.45, bottom: 0, right: 0)

            button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 4.0

        }
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

        viewModel.didViewUpdated
            .subscribe(onNext: {[weak self] in try? self?.applyStylingToButtons()})
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
