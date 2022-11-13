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
        filter: String?
    ) async throws -> Core.TransparentAccountsResponse {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            .init(name: "page", value: .init(page)),
            .init(name: "size", value: .init(size)),
            .init(name: "filter", value: filter),
        ].filter { !($0.value ?? "").isEmpty }
        
        guard let url = urlComponents?.url else {
            throw InvalidURL(string: urlComponents?.string)
        }
        
        let response = try await jsonAPI.request(
            url: url,
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
