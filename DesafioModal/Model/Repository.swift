//
//  Item.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

import Foundation

public struct Repository: Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fullName = "full_name"
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
    }

    let name: String
    let fullName: String
    let createdAt: String
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        fullName = try values.decode(String.self, forKey: .fullName)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        stargazersCount = try values.decode(Int.self, forKey: .stargazersCount)
        watchersCount = try values.decode(Int.self, forKey: .watchersCount)
        forksCount = try values.decode(Int.self, forKey: .forksCount)
    }

    private static func fullnameFormat(fullName: String) -> String {
        var tempFullName = fullName
        if let dotRange = tempFullName.range(of: "/") {
            tempFullName.removeSubrange(dotRange.lowerBound..<tempFullName.endIndex)
        }
        return tempFullName
    }

}
