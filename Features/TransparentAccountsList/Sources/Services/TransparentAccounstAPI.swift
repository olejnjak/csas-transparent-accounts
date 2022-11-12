import Core
import Foundation

public final class TransparentAccountsAPI: Core.TransparentAccountsAPI {
    public struct Dependencies {
        public let credentialsProvider: CredentialsProvider
        public let jsonAPI: JSONAPIServicing
        
        public init(
            credentialsProvider: CredentialsProvider,
            jsonAPI: JSONAPIServicing
        ) {
            self.credentialsProvider = credentialsProvider
            self.jsonAPI = jsonAPI
        }
    }
    
    private let baseURL: URL
    private let crendentialsProvider: CredentialsProvider
    private let jsonAPI: JSONAPIServicing
    
    // MARK: - Initializers
    
    public init(
        dependencies: Dependencies,
        baseURL: URL
    ) {
        self.baseURL = baseURL
        
        crendentialsProvider = dependencies.credentialsProvider
        jsonAPI = dependencies.jsonAPI
    }
    
    // MARK: - Public interface
    
    public func transparentAccounts(
        page: Int,
        size: Int,
        filter: String
    ) async throws -> Core.TransparentAccountsResponse {
        let response = try await jsonAPI.request(
            url: baseURL,
            headers: [
                .apiKeyHeaderName: webAPIKey()
            ],
            responseBodyType: TransparentAccountsResponse.self
        )
        
        guard response.statusCode == 200 else {
            throw UnexpectedResponseCode(
                got: response.statusCode,
                expected: 200
            )
        }
        
        if let body = response.body {
            return body
        } else {
            throw NoBody()
        }
    }
    
    // MARK: - Private helpers
    
    private func webAPIKey() throws -> String {
        if let apiKey = crendentialsProvider.apiKey, !apiKey.isEmpty {
            return apiKey
        }
        
        struct MissingAPIKey: Error {
            
        }
        
        throw MissingAPIKey()
    }
}

private extension String {
    static let apiKeyHeaderName = "WEB-API-key"
}
