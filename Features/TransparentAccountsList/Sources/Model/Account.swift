import Core
import Foundation

public struct Account {
    public let name: String
    public let accountNumber: String
    public let balance: Double
    public let currency: String
    public let description: String?
    public let note: String?
}

extension Core.Account_API {
    var domain: Account? {
        guard
            let accountNumber,
            let bankCode,
            let balance,
            let currency,
            let name
        else {
            // TODO: Log failed conversion
            return nil
        }
        
        return .init(
            name: name,
            accountNumber: accountNumber + "/" + bankCode,
            balance: balance,
            currency: currency,
            description: description,
            note: note
        )
    }
}
