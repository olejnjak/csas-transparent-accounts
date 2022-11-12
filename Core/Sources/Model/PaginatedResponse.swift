import Foundation

public protocol Page: Decodable {
    static var pageFieldName: String { get }
}

/// Model for paginated response from Transparent Accounts API
///
/// Needs customized CodingKeys as field name for page items differs from EP to EP,
/// also all fields need to be optional as no field is required by JSON schema
public struct PaginatedResponse<P: Page>: Decodable {
    private struct CodingKeys: CodingKey {
        static var size: Self { .init("size") }
        static var nextPage: Self { .init("nextPage") }
        static var page: Self { .init(P.pageFieldName) }
        
        var stringValue: String
        var intValue: Int?

        init(_ string: String) {
            stringValue = string
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = String(intValue)
        }
    }
    
    public let size: Int?
    public let nextPage: Int?
    public let page: P?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.size = try container.decodeIfPresent(Int.self, forKey: .size)
        self.nextPage = try container.decodeIfPresent(Int.self, forKey: .nextPage)
        self.page = try container.decodeIfPresent(P.self, forKey: .page)
    }
}
