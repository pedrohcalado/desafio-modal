// GithubResponse.swift

public struct GithubResponse: Decodable {

    enum CodingKeys: CodingKey {
        case items
    }

    let items: [Repository]

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        items = try values.decode([Repository].self, forKey: .items)
    }
}
