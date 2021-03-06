
import Foundation

extension String {
    var dateFromISO8601: Date? {
        return TGDateFormats.iso8601.date(from: self)
    }
    
    var dateFromISO8601WithoutTimeZone: Date? {
        return TGDateFormats.iso8601WithoutTimeZone.date(from: self)
    }
    
    static var emptyEntity: Any {
        return "" as Any
    }
    
    static var emptyNilEntity: Any {
        let empty: String? = nil
        return empty as Any
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedWithFormat(arguments: CVarArg...) -> String {
        return String.localizedStringWithFormat(self.localized, arguments)
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
    
    var withoutSpacesAndNewLines: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
