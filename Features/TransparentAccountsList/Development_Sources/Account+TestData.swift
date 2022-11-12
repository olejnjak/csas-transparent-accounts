import Foundation

extension Account {
    static func test(
        name: String = "SVAZEK OBCÍ - REGION DOLNÍ BEROUNKA",
        accountNumber: String = "000000-2906478309/0800",
        balance: Double = 1063961.87,
        currency: String = "CZK",
        description: String? = "sbírka pro Nepál",
        note: String? = "Příjmový účet"
    ) -> Self {
        .init(
            name: name,
            accountNumber: accountNumber,
            balance: balance,
            currency: currency,
            description: description,
            note: note
        )
    }
}
