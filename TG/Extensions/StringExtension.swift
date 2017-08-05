
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
}
