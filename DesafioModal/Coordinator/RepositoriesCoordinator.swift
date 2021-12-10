// RepositoriesCoordinator.swift

import Foundation
import RxSwift

class RepositoriesCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    var viewModel: RepositoriesViewModel!

    override func start() {
        let viewController = RepositoriesViewController()

        viewModel = RepositoriesViewModel(githubService: GithubService())
        viewController.viewModel = viewModel

        viewModel.didRepositoryCellTapped
            .subscribe(onNext: { [weak self] repository in self?.transitionToDetailView(repository: repository) })
            .disposed(by: disposeBag)

        viewModel.didFilterSettingsButtonTapped
            .subscribe(onNext: { [weak self] in self?.transitionToFilterView() })
            .disposed(by: disposeBag)

        navigationController.viewControllers = [viewController]
        viewModel.didViewUpdated.onNext(())
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

    override func didFinish(coordinator: Coordinator) {
        super.didFinish(coordinator: coordinator)
        viewModel.didViewUpdated.onNext(())
    }

}
