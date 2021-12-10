//
//  DetailViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 09/12/21.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet var repoView: UIView!

    @IBOutlet var backButton: UIButton!
    @IBOutlet var shareButton: UIButton!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var stargazersLabel: UILabel!

    @IBOutlet var commitsLabel: UILabel!
    @IBOutlet var releasesLabel: UILabel!
    @IBOutlet var branchesLabel: UILabel!
    @IBOutlet var colaboratorsLabel: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBindings()

        view.backgroundColor = UIColor(red: 235 / 255, green: 236 / 255, blue: 238 / 255, alpha: 1.0)
        roundTop(viewName: repoView)
    }

    private func setUpBindings() {
        backButton.rx.tap
            .bind { [weak self] in self?.viewModel.leaveDetailView() }
            .disposed(by: disposeBag)

        shareButton.rx.tap
            .bind { [weak self] in
                guard let path = self?.viewModel.repository.fullName else {
                    return
                }

                guard let link = NSURL(string: "https://github.com/\(path)") else {
                    return
                }

                let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
                self?.present(activityViewController, animated: true, completion: nil)
            }.disposed(by: disposeBag)

        viewModel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.stargazers
            .bind(to: stargazersLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.commits
            .bind(to: commitsLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.releases
            .bind(to: releasesLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.branches
            .bind(to: branchesLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.colaborators
            .bind(to: colaboratorsLabel.rx.text)
            .disposed(by: disposeBag)
    }

// da certo ae o coisa linda app bonito amo modalmais <3 modal na veia #EuSouModal
}
