
import Foundation

extension Date {
    var iso8601: String {
        return TGDateFormats.iso8601WithoutTimeZone.string(from: self)
    }
    static let now = Date()
}
