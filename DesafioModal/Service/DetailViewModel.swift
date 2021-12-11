// DetailViewModel.swift

import RxSwift
import UIKit

class DetailViewModel {
    private let githubService: GithubService

    let repository: Repository!

    let name = BehaviorSubject(value: "")
    let profilePicture: Observable<UIImage?>
    let stargazers = BehaviorSubject(value: "...")

    let commits = BehaviorSubject(value: "...")
    let releases = BehaviorSubject(value: "...")
    let branches = BehaviorSubject(value: "...")
    let colaborators = BehaviorSubject(value: "...")

    let readme = PublishSubject<String>()

    let didBackButtonTapped = PublishSubject<Void>()

    init(repository: Repository, githubService: GithubService) {
        self.repository = repository
        self.githubService = githubService

        name.onNext(repository.fullName)
        stargazers.onNext("\(repository.stargazersCount)")

        let data = try? Data(contentsOf: URL(string: "https://github.com/\(repository.owner).png")!)
        self.profilePicture = Observable.just(UIImage(data: data!))

        fetchDataFromGithubApi()
    }

    func leaveDetailView() {
        didBackButtonTapped.onNext(())
    }

    func loadReadme() {
        githubService.getReadmeOf(repository) { [weak self] result in
            switch result {
            case .success(let html):
                self?.readme.onNext(html)

            default:
                self?.readme.onNext("<html><body><p>Não foi possível carregar o README do repositório</p></body></html>")
            }
        }
    }

    private func fetchDataFromGithubApi() {
        githubService.getBranchesOf(repository) { [weak self] result in
            switch result {
            case .success(let branches):
                self?.branches.onNext("\(branches.count)")
            default:
                self?.branches.onNext("...")
            }
        }

        githubService.getReleasesOf(repository) { [weak self] result in
            switch result {
            case .success(let releases):
                self?.releases.onNext("\(releases.count)")
            default:
                self?.releases.onNext("...")
            }
        }

        githubService.getContributorsOf(repository) { [weak self] result in
            switch result {
            case .success(let contributors):
                self?.colaborators.onNext("\(contributors.count)")
                self?.commits.onNext(String(contributors.map { $0.contributions }.reduce(0, +)))
            default:
                self?.colaborators.onNext("...")
                self?.commits.onNext("...")
            }
        }
    }
}
