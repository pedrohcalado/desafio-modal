// FilterCoordinator.swift

import Foundation
import RxSwift

class FilterCoordinator: BaseCoordinator {

    private let disposeBag = DisposeBag()

    override func start() {
        let viewController = FilterViewController()

        let viewModel = FilterViewModel()
        viewController.viewModel = viewModel

        viewModel.didCloseButtonTapped
            .subscribe(onNext: { [weak self] in self?.goBack() })
            .disposed(by: disposeBag)

        navigationController.pushViewController(viewController, animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.didFinish(coordinator: self)
    }

}
