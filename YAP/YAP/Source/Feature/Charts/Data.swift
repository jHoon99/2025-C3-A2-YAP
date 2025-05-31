//
//  Data.swift
//  YAP
//
//  Created by oliver on 5/31/25.
//

import Foundation

func date(year: Int, month: Int, day: Int = 1) -> Date {
  Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

struct Data {
  struct Series: Identifiable {
    let name: String
    let measurements: [(day: Date, amount: Double)]
    var id: String { name }
  }
  
  static let bodyCompositionData: [Series] = [
    .init(name: "weight", measurements: [
      (day: date(year: 2022, month: 5, day: 2), amount: 80.2),
      (day: date(year: 2022, month: 5, day: 9), amount: 80.0),
      (day: date(year: 2022, month: 5, day: 16), amount: 79.8),
      (day: date(year: 2022, month: 5, day: 23), amount: 79.2),
      (day: date(year: 2022, month: 5, day: 30), amount: 78.8),
      (day: date(year: 2022, month: 6, day: 7), amount: 78.6),
      (day: date(year: 2022, month: 6, day: 14), amount: 78.2)
    ]),
    .init(name: "body fat mass", measurements: [
      (day: date(year: 2022, month: 5, day: 2), amount: 15.2),
      (day: date(year: 2022, month: 5, day: 9), amount: 15.0),
      (day: date(year: 2022, month: 5, day: 16), amount: 14.8),
      (day: date(year: 2022, month: 5, day: 23), amount: 14.7),
      (day: date(year: 2022, month: 5, day: 30), amount: 14.2),
      (day: date(year: 2022, month: 6, day: 7), amount: 14.0),
      (day: date(year: 2022, month: 6, day: 14), amount: 13.2)
    ]),
    .init(name: "skeletal muscle mass", measurements: [
      (day: date(year: 2022, month: 5, day: 2), amount: 17.2),
      (day: date(year: 2022, month: 5, day: 9), amount: 17.2),
      (day: date(year: 2022, month: 5, day: 16), amount: 17.3),
      (day: date(year: 2022, month: 5, day: 23), amount: 17.4),
      (day: date(year: 2022, month: 5, day: 30), amount: 17.6),
      (day: date(year: 2022, month: 6, day: 7), amount: 18.0),
      (day: date(year: 2022, month: 6, day: 14), amount: 18.2)
    ])
  ]
}
