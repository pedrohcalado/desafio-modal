//
//  GithubService.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

// swiftlint:disable all

import Foundation

class GithubService {
    static let shared = GithubService()
    private init() {}

    func getRepositories( query q: String, sort: githubSort = .bestMatch,
                          order: githubOrder = .decrescente, per_page: Int = 30,
                          page: Int = 1, then handler: @escaping (GithubResponse) -> Void
    ) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "order", value: order.rawValue),
            URLQueryItem(name: "per_page", value: String(per_page)),
            URLQueryItem(name: "page", value: String(page))
        ]

        
        if let url = components.url {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(GithubResponse.self, from: data)
                    handler(json)
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
}

enum githubSort: String {
    case stars = "stars"
    case forks = "forks"
    case helpWantedIssues = "help-wanted-issues"
    case bestMatch = "bestmatch"
    case updated = "updated"
}

enum githubOrder: String {
    case crescente = "asc"
    case decrescente = "desc"
}
