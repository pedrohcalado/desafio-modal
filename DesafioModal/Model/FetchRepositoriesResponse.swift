// GithubResponse.swift

public struct FetchRepositoriesResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }

    let repositories: [Repository]

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        repositories = try values.decode([Repository].self, forKey: .repositories)
    }
}
