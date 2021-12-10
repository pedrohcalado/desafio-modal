// DetailCoordinator.swift

import Foundation
import RxSwift

class DetailCoordinator: BaseCoordinator {

    private let disposeBag = DisposeBag()
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
        super.init()
    }

    override func start() {
        let viewController = DetailViewController()
        viewController.modalTransitionStyle = .coverVertical

        let viewModel = DetailViewModel(repository: self.repository, githubService: GithubService())
        viewController.viewModel = viewModel

        viewModel.didBackButtonTapped
            .subscribe(onNext: { [weak self] in self?.goBack() })
            .disposed(by: disposeBag)

        navigationController.present(viewController, animated: true)
    }

    func goBack() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.didFinish(coordinator: self)
    }

}
