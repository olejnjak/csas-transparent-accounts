import Core
import Foundation

public struct Account: Hashable {
    public let name: String
    public let accountNumber: String
    public let balance: String
    public let description: String?
    public let note: String?
}

extension Core.Account_API {
    var domain: Account? {
        guard
            let accountNumber,
            let bankCode,
            let currency,
            let balance = balance.flatMap ({ NumberFormatter.currencyFormatter(currency).string(from: .init(value: $0)) }),
            let name
        else {
            // TODO: Log failed conversion
            return nil
        }
        
        return .init(
            name: name,
            accountNumber: accountNumber + "/" + bankCode,
            balance: balance,
            description: description,
            note: note
        )
    }
}
