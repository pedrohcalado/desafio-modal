// RepositoriesCoordinator.swift

import Foundation
import RxSwift

class RepositoriesCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    override func start() {
        let viewController = RepositoriesViewController()

        let viewModel = RepositoriesViewModel(githubService: GithubService())
        viewController.viewModel = viewModel

        viewModel.didRepositoryCellTapped
            .subscribe(onNext: { [weak self] repository in self?.transitionToDetailView(repository: repository) })
            .disposed(by: disposeBag)

        viewModel.didFilterSettingsButtonTapped
            .subscribe(onNext: { [weak self] in self?.transitionToFilterView() })
            .disposed(by: disposeBag)

        navigationController.viewControllers = [viewController]
    }

    func transitionToFilterView() {
        let coordinator = FilterCoordinator()
        coordinator.navigationController = navigationController

        start(coordinator: coordinator)
    }

    func transitionToDetailView(repository: Repository) {
        let coordinator = DetailCoordinator(repository: repository)
        coordinator.navigationController = navigationController

        start(coordinator: coordinator)
    }

}
