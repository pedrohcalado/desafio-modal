//
//  GithubService.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

// swiftlint:disable all

import Foundation

public final class GithubService {
    
    public enum Result<T> {
        case success(result: T)
        case error(message: String?)
    }
    
    public enum Sorting: String {
        case stars = "stars"
        case forks = "forks"
        case helpWantedIssues = "help-wanted-issues"
        case bestMatch = "bestmatch"
        case updated = "updated"
    }
    
    public enum Order: String {
        case asc = "asc"
        case desc = "desc"
    }
    
    func searchRepositories(query: String, sortingBy sorting: Sorting = .bestMatch, orderBy order: Order = .desc, count: Int = 30, page: Int = 1, completion: @escaping (Result<GithubResponse>) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sorting.rawValue),
            URLQueryItem(name: "order", value: order.rawValue),
            URLQueryItem(name: "per_page", value: String(count)),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        
        guard let url = components.url else {
            completion(.error(message: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var result: Result<GithubResponse>
            
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
                let githubResponse = try decoder.decode(GithubResponse.self, from: data)
                
                result = .success(result: githubResponse)
            } catch let error as NSError {
                result = .error(message: error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
}
