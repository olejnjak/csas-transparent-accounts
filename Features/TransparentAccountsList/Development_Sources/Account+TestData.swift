import Foundation

extension Account {
    static func test(
        name: String = "SVAZEK OBCÍ - REGION DOLNÍ BEROUNKA",
        accountNumber: String = "000000-2906478309/0800",
        balance: String = NumberFormatter.currencyFormatter("CZK", locale: .init(identifier: "cs_CZ")).string(from: .init(value: 1063961.87))!,
        description: String? = "sbírka pro Nepál",
        note: String? = "Příjmový účet"
    ) -> Self {
        .init(
            name: name,
            accountNumber: accountNumber,
            balance: balance,
            description: description,
            note: note
        )
    }
}
