//
//  Item.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

// swiftlint:disable all

import Foundation

struct Item: Codable {
    let name: String
    let full_name: String
    let created_at: String
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let description: String?
}
