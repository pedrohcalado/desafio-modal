//
//  GithubService.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

import Foundation

public final class GithubService {

    public enum Result<T> {
        case success(result: T)
        case error(message: String?)
    }

    public enum Sorting: String {
        case stars
        case forks
        case updated
    }

    public enum Order: String {
        case asc
        case desc
    }

    private enum Resource: String {
        case commits
        case branches
        case contributors
        case releases
    }

    public func searchRepositories(
        query: String,
        sorting: Sorting? = nil,
        order: Order = .desc,
        count: Int = 30, page: Int = 1,
        completion: @escaping (Result<FetchRepositoriesResponse>) -> Void
    ) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sorting == nil ? "bestmatch" : sorting?.rawValue),
            URLQueryItem(name: "order", value: order.rawValue),
            URLQueryItem(name: "per_page", value: String(count)),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let url = components.url else {
            completion(.error(message: nil))
            return
        }

        self.request(url: url, completion: completion)
    }

    public func getCommitsOf(_ repository: Repository, completion: @escaping (Result<[Commit]>) -> Void) {
        self.getResourceOf(repository, resource: .commits, completion: completion)
    }

    public func getBranchesOf(_ repository: Repository, completion: @escaping (Result<[Branch]>) -> Void) {
        self.getResourceOf(repository, resource: .branches, completion: completion)
    }

    public func getContributorsOf(_ repository: Repository, completion: @escaping (Result<[Contributor]>) -> Void) {
        self.getResourceOf(repository, resource: .contributors, completion: completion)
    }

    public func getReleasesOf(_ repository: Repository, completion: @escaping (Result<[Release]>) -> Void) {
        self.getResourceOf(repository, resource: .releases, completion: completion)
    }

    private func getResourceOf<T: Decodable>(_ repository: Repository, resource: Resource, completion: @escaping (Result<T>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/repos/\(repository.fullName)/\(resource.rawValue)"
        components.queryItems = [
            URLQueryItem(name: "per_page", value: String(100))
        ]

        guard let url = components.url else {
            completion(.error(message: nil))
            return
        }

        self.request(url: url, completion: completion)
    }

    func getReadmeOf(_ repository: Repository, completion: @escaping (Result<String>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/repos/\(repository.fullName)/readme"

        guard let url = components.url else {
            completion(.error(message: nil))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github-commitcomment.html+json", forHTTPHeaderField: "accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<String>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            if let error = error {
                result = .error(message: error.localizedDescription)
                return
            }

            guard let data = data else {
                result = .error(message: nil)
                return
            }

            let response = String(data: data, encoding: .utf8)

            if response != nil {
                result = .success(result: response!)
            } else {
                result = .error(message: nil)
            }

        }.resume()
    }

    private func request<T: Decodable>(url: URL, completion: @escaping (Result<T>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var result: Result<T>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            if let error = error {
                result = .error(message: error.localizedDescription)
                return
            }

            guard let data = data else {
                result = .error(message: nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)

                result = .success(result: response)
            } catch let error as NSError {
                result = .error(message: error.localizedDescription)
            }
        }

        task.resume()
    }
}
