
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
    
    var mondayOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = 2
        return calendar.date(from: components)!
    }
    
    var normalized: Date {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let date = calendar.date(from: components)!
        
        return date
    }
    
    var sundayOfWeek: Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.day, .month, .year], from: mondayOfWeek)
        components.day = (components.day ?? 0) + 6
        let date = calendar.date(from: components)!
        
        return date
    }
    
    var weekFriday: Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.day, .month, .year], from: mondayOfWeek)
        components.day = (components.day ?? 0) + 4
        let date = Calendar.current.date(from: components)!
        
        return date
    }
    
    var startOfDay: Date {
        let calendar = Calendar.current
        
        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))!
    }
    
    static func getDates(from range: ClosedRange<Date>, with step: Int = 1) -> [Date] {
        let calendar = Calendar.current
        var dates = [range.lowerBound]
        let units = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(units, from: range.lowerBound)
        var acc = step
        
        while true {
            var tmpComponents = components
            tmpComponents.day = (components.day ?? 0) + acc
            let date = calendar.date(from: tmpComponents)!
            
            if date < range.upperBound {
                dates.append(date)
            } else {
                dates.append(range.upperBound)
                break
            }
            
            acc += step
        }
        
        return dates
    }
}


