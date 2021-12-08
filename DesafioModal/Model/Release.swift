// Release.swift

public struct Release: Decodable {
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }

    let tagName: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        tagName = try values.decode(String.self, forKey: .tagName)
    }
}
