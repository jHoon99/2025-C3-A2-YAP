//
//  Date+Ex.swift
//  YAP
//
//  Created by oliver on 6/3/25.
//

import Foundation

extension Date {
  var formattedYMD: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    return formatter.string(from: self)
  }
}
