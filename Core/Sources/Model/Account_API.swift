import Foundation

public typealias TransparentAccountsResponse = PaginatedResponse<Account_API>

public struct Account_API: Page {
    public static let pageFieldName = "accounts"
}
