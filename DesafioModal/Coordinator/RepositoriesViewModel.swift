// RepositoriesViewModel.swift

import RxCocoa
import RxSwift

class RepositoriesViewModel {

    private let githubService: GithubService
    let filterService: FilterService

    let searchQuery = BehaviorSubject(value: "")
    var repositories: [Repository] = []

    let didSearchEnded = PublishSubject<Void>()
    let didRepositoryCellTapped = PublishSubject<Repository>()
    let didFilterSettingsButtonTapped = PublishSubject<Void>()

    let didViewUpdated = PublishSubject<Void>()

    init(githubService: GithubService) {
        self.githubService = githubService
        self.filterService = FilterService.shared
        search()
    }

    func search() {
        guard var query = try? searchQuery.value() else {
            return
        }

        if query.isEmpty {
            query = "language:swift"
        }

        githubService.searchRepositories(query: query, sorting: FilterService.shared.sorting, order: FilterService.shared.order) { [weak self] result in
            switch result {
            case .success(let response):
                self?.repositories = response.repositories
                self?.didSearchEnded.onNext(())

            default:
                self?.repositories = []

            }
        }
    }

    func showDetailsOfRepository(_ repository: Repository) {
        self.didRepositoryCellTapped.onNext(repository)
    }

    func showFilterSettings() {
        self.didFilterSettingsButtonTapped.onNext(())
    }

    func clearFilters() {
        FilterService.shared.reset()

        search()
    }

}
