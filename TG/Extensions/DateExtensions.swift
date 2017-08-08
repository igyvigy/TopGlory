
import Foundation

extension Date {
    var iso8601: String {
        return TGDateFormats.iso8601WithoutTimeZone.string(from: self)
    }
    static let now = Date()
    
    static let minute = 60, hour = minute * 60, day = hour * 24, week = day * 7
    
    func timeFromNow() -> String {
        let timeDifference = Int(NSDate().timeIntervalSince(self))
        var timestamp: String
        let weeks = timeDifference / Date.week, days = timeDifference / Date.day, hours = timeDifference / Date.hour, minutes = timeDifference / Date.minute
        if weeks > 0 { timestamp = weeks != 1 ? "\(weeks) weeks ago" : "\(weeks) week ago" }
        else if days > 0 { timestamp = days != 1 ? "\(days) days ago" : "\(days) day ago" }
        else if hours > 0 { timestamp = hours != 1 ? "\(hours) hours ago" : "\(hours) hour ago"}
        else if minutes == 0 { timestamp = "now" }
        else { timestamp = minutes != 1 ? "\(minutes) minutes ago" : "\(minutes) minute ago" }
        return timestamp
    }
}

