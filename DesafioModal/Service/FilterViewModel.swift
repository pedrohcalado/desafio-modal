// FilterViewModel.swift

import RxSwift
import RxRelay

class FilterViewModel {

    var sorting = BehaviorSubject<GithubService.Sorting?>(value: FilterService.shared.sorting)
    var order = BehaviorSubject<GithubService.Order>(value: FilterService.shared.order)

    let didCloseButtonTapped = PublishSubject<Void>()
    let didFilterChanged = PublishSubject<Void>()

    func closeFilterView() {
        didCloseButtonTapped.onNext(())
    }

    func resetFilters() {
        sorting.onNext(nil)
        order.onNext(.desc)

        didFilterChanged.onNext(())
    }

    func applyFilters() {
        FilterService.shared.sorting = try? sorting.value()
        FilterService.shared.order = (try? order.value()) ?? .desc

        closeFilterView()
    }

    func changeSorting(rawValue: String?) {
        if rawValue == nil {
            return
        }

        guard let sorting = GithubService.Sorting(rawValue: rawValue!) else {
            return
        }

        defer {
            didFilterChanged.onNext(())
        }

        if let current = try? self.sorting.value() {
            if current == sorting {
                self.sorting.onNext(nil)
                return
            }
        }

        self.sorting.onNext(sorting)
    }

    func changeOrder(rawValue: String?) {
        if rawValue == nil {
            return
        }

        guard let order = GithubService.Order(rawValue: rawValue!) else {
            return
        }

        self.order.onNext(order)
        didFilterChanged.onNext(())
    }
}
