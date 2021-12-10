// FilterService.swift

import RxRelay

public final class FilterService {

    public static var shared = FilterService()

    var sorting: GithubService.Sorting?
    var order = GithubService.Order.desc

    private init() {}

    func reset() {
        self.sorting = nil
        self.order = .desc
    }

}
