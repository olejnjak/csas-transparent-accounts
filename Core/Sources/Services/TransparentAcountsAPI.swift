import Foundation

public protocol TransparentAccountsAPI {
    func transparentAccounts(
        page: Int,
        size: Int,
        filter: String?
    ) async throws -> TransparentAccountsResponse
}
