import Core
import Foundation
import TransparentAccountsList

final class AppDependency {
    private let jsonAPI = JSONAPIService()
    
    lazy var transparentAccountsAPI = TransparentAccountsList.TransparentAccountsAPI(
        dependencies: .init(credentialsProvider: self, jsonAPI: jsonAPI),
        // swiftlint:disable:next force_unwrapping
        baseURL: .init(string: Environment.baseURL)!
    )
}

extension AppDependency: CredentialsProvider {
    var apiKey: String? { Environment.apiKey }
}

let appDependencies = AppDependency()
