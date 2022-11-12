import Foundation

public typealias TransparentAccountsResponse = PaginatedResponse<Account_API>

public struct Account_API: Page {
    public static let pageFieldName = "accounts"
    
    public let accountNumber: String?
    public let bankCode: String?
    public let balance: Double?
    public let currency: String?
    public let name: String?
    public let description: String?
    public let note: String?
}
