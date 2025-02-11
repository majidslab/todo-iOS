//
//  DateExtension.swift
//  todo-online
//
//  Created by Majid Jamali on 1/16/25.
//

import Foundation

extension Date {
    
    func getDateWithoutTime() -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .day)
    }
    
    func getDaysBefore(_ days: Int) -> [Date] {
        var dates = [Date]()
        for i in (1...days).reversed() {
            if let date = Calendar.current.date(byAdding: .day, value: -1 * i, to: self) {
                dates.append(date)
            }
        }
        return dates
    }
    
    func getDaysAfter(_ days: Int) -> [Date] {
        var dates = [Date]()
        for i in (1...days) {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: self) {
                dates.append(date)
            }
        }
        return dates
    }
    
    func getShortWeekdaySymbol() -> String {
        let formatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: self) - 1
        return formatter.shortWeekdaySymbols[weekday]
    }
    
    func getDay() -> String {
        return Calendar.current.component(.day, from: self).formatted()
    }
    
    func getMonth() -> String {
        let formatter = DateFormatter()
        let month = Calendar.current.component(.month, from: self) - 1
        return formatter.shortMonthSymbols[month]
    }
    
    func isFirstDayOrLastDayOfMonth() -> Bool {
        var first = Calendar.current.dateComponents([.year, .month], from: self)
        first.day = 1
        guard let firstDate = Calendar.current.date(from: first) else {
            return false
        }
        
        var last = Calendar.current.dateComponents([.month, .day], from: self)
        last.day = -1
        last.month = 1
        guard let lastDate = Calendar.current.date(byAdding: last, to: firstDate) else {
            return false
        }
        
        return isToday(firstDate) || isToday(lastDate)
    }
    
    func toDateStringFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
}
