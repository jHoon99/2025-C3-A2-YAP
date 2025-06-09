//
//  Date+Ex.swift
//  YAP
//
//  Created by oliver on 6/3/25.
//

import Foundation

extension Date {
  var startOfDay: Date {
    Calendar.current.startOfDay(for: self)
  }
  
  var formattedYMD: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    return formatter.string(from: self)
  }
  
  static func of(year: Int, month: Int, day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
  }
}
