//
//  DateTime.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

class DateTime: NSObject {
    
    static let calendar = Calendar.current
    
    static func getLocalTime(dateString: String) -> String?{
        let dateformatter = DateFormatter()
        dateformatter.timeZone = .current
        dateformatter.dateFormat = Date.lastUpdatedAtDateFormat
        let toDate = dateformatter.date(from: dateString)
        if toDate != nil{
            dateformatter.dateFormat = Date.simpleDateFormatWithHourAndMinute
            return dateformatter.string(from: toDate!)
        }else{
            return nil
        }
    }
    
    static func currentTimeForLastUpdateAt(format: String = Date.lastUpdatedAtDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    static func formatDate(date: Date?, dateFormat: String) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        if date != nil{
            return dateformatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    static func stringToDate(dateString: String, dateFormat: String) -> Date?{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = dateFormat
        return Date.addDays(day: 1, fromDate: dateformatter.date(from: dateString) ?? Date())
    }
    
    static func stringToDatetaskUpdate(dateString: String, dateFormat: String) -> Date?{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = dateFormat
        return dateformatter.date(from: dateString)
    }
    
    static func convertDateFormater(_ date: String, currentFormat: String, newFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        if let date = dateFormatter.date(from: date){
            dateFormatter.dateFormat = newFormat
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    static func secondsToDateString(seconds: String, dateFormat: String) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        if let toDouble = Double(seconds){
            let toDate = Date.init(timeIntervalSince1970: toDouble)
            return dateformatter.string(from: toDate)
        }
        return ""
    }
 
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    static func weekdays(fromDate: Date, toDate: Date, holidays: [String]) -> Int { // }[Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            if !holidays.contains(Date().dayNumberOfWeek(date: date)){
                dates.append(date)
            }
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        let weekdays = dates.filter{!calendar.isDateInWeekend($0)}
        return weekdays.count //  return dates
    }
  
}

extension Date {
   
    static let inspectionDateFormat: String = "yyyy-MM-dd HH:mm:ss Z"
    static let lastUpdatedAtDateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let shareLogTimeFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let styleInspectDateFormat: String = "yyyy-MM-dd'T'HH:mm:ss"
    static let simpleDateFormat: String = "yyyy-MM-dd"
    static let fileUploadAPIDateFormat: String = "yyyy-MM-dd:HH:mm:ss"
    static let fileUploadDateFormat: String = "yyyy/MM/dd"
    static let notificationFormat: String = "dd-MM-yyyy"
    static let simpleDateFormatUI: String = "dd MMM yyyy"
    static let simpleDateFormatWithHourAndMinute : String = "yyyy-MM-dd HH:mm"
    static let hourAndMinuteDateFormat: String = "HH:mm"
    
    static let calendar = Calendar.current
    
    func withAddedMinutes(minutes: Double) -> Date {
        addingTimeInterval(minutes * 60)
    }
    
    func withAddedHours(hours: Double) -> Date {
        withAddedMinutes(minutes: hours * 60)
    }
    
    static func withTime(date: Date = Date(), hour:Int, minute:Int, second:Int) -> Date{
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = hour
        components.minute = minute
        components.second = second
        let modifyDate = calendar.date(from: components)
        return modifyDate ?? date
    }
        
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    
    static var tomorrow:  Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    
    static var nextTo30Days:  Date {
        return Calendar.current.date(byAdding: .day, value: 30, to: Date().noon)!
    }
    
    static func reduceDays(day: Int, fromDate: Date) -> Date{
        return Calendar.current.date(byAdding: .day, value: -(day), to: fromDate)!
    }
    
    static func addDays(day: Int, fromDate: Date) -> Date{
        return Calendar.current.date(byAdding: .day, value: +(day), to: fromDate)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
  
    func dayNumberOfWeek(date: Date) -> String {
        return "\(Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0)"
    }
}

//extension Calendar {
//    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
//        let numberOfDays = dateComponents([.day], from: from, to: to)
//        return numberOfDays.day!
//    }
//}
