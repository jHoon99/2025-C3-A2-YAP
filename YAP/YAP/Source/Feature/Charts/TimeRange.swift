//
//  TimeRange.swift
//  YAP
//
//  Created by oliver on 6/4/25.
//

import Foundation

enum TimeRange: String, CaseIterable, Identifiable {
  case threeMonths = "3개월"
  case sixMonths = "6개월"
  case oneYear = "1년"
  case custom = "기간 설정"
  
  var id: String { rawValue }
  
  func isWithinRange(from startDate: Date, to endDate: Date) -> ((Date) -> Bool) {
    switch self {
    case .threeMonths:
      guard let threeMonthsAgo = Calendar.current.date(
        byAdding: .month,
        value: -3,
        to: endDate
      ) else {
        return { _ in false }
      }
      
      return { day in day >= threeMonthsAgo}
      
    case .sixMonths:
      guard let sixMonthsAgo = Calendar.current.date(
        byAdding: .month,
        value: -6,
        to: endDate
      ) else {
        return { _ in false }
      }
      
      return { day in day >= sixMonthsAgo }
      
    case .oneYear:
      guard let oneYearAgo = Calendar.current.date(
        byAdding: .year,
        value: -1,
        to: endDate
      ) else {
        return { _ in false }
      }
      
      return { day in day >= oneYearAgo }
      
    case .custom:
      return { day in day >= startDate && day <= endDate }
    }
  }
}
