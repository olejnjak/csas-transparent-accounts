import Foundation

public extension NumberFormatter {
    private static var cachedFormatters = [String: NumberFormatter]()
    
    static func currencyFormatter(
        _ currency: String,
        locale: Locale = .autoupdatingCurrent
    ) -> NumberFormatter {
        let key = currency + "/" + locale.identifier
        
        if let formatter = cachedFormatters[key] {
            return formatter
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = currency
        formatter.locale = locale
        cachedFormatters[key] = formatter
        return formatter
    }
}
