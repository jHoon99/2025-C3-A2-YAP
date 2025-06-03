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
  
  /// preview를 위한 예시 데이터
  static let bodyCompositionData: [Series] = [
    .init(name: "체중 (kg)", measurements: [
      (day: date(year: 2022, month: 5, day: 2), amount: 80.2),
      (day: date(year: 2022, month: 5, day: 9), amount: 80.0),
      (day: date(year: 2022, month: 5, day: 16), amount: 79.8),
      (day: date(year: 2022, month: 5, day: 23), amount: 79.2),
      (day: date(year: 2022, month: 5, day: 30), amount: 78.8),
      (day: date(year: 2022, month: 6, day: 7), amount: 78.6),
      (day: date(year: 2022, month: 6, day: 14), amount: 78.2)
    ]),
    .init(name: "체지방량 (kg)", measurements: [
      (day: date(year: 2022, month: 5, day: 2), amount: 15.2),
      (day: date(year: 2022, month: 5, day: 9), amount: 15.0),
      (day: date(year: 2022, month: 5, day: 16), amount: 14.8),
      (day: date(year: 2022, month: 5, day: 23), amount: 14.7),
      (day: date(year: 2022, month: 5, day: 30), amount: 14.2),
      (day: date(year: 2022, month: 6, day: 7), amount: 14.0),
      (day: date(year: 2022, month: 6, day: 14), amount: 13.2)
    ]),
    .init(name: "골격근량 (kg)", measurements: [
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

extension Inbody {
  static var sampleData: [Inbody] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return [
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-06-05")!,
        weight: 78.0,
        height: 175.0,
        age: 31,
        bodyFatMass: 17.2,
        basalMetabolicRate: 1600,
        skeletalMuscleMass: 31.0,
        leanBodyMass: 60.8,
        bodyFatPercentage: 22.0
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-07-12")!,
        weight: 77.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 16.7,
        basalMetabolicRate: 1605,
        skeletalMuscleMass: 31.3,
        leanBodyMass: 61.0,
        bodyFatPercentage: 21.5
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-08-08")!,
        weight: 77.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 16.1,
        basalMetabolicRate: 1610,
        skeletalMuscleMass: 31.5,
        leanBodyMass: 61.3,
        bodyFatPercentage: 21.0
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-09-04")!,
        weight: 77.0,
        height: 175.0,
        age: 31,
        bodyFatMass: 15.5,
        basalMetabolicRate: 1615,
        skeletalMuscleMass: 31.7,
        leanBodyMass: 61.6,
        bodyFatPercentage: 20.5
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-10-10")!,
        weight: 76.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 15.0,
        basalMetabolicRate: 1620,
        skeletalMuscleMass: 31.9,
        leanBodyMass: 62.0,
        bodyFatPercentage: 20.0
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-11-15")!,
        weight: 76.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 14.5,
        basalMetabolicRate: 1625,
        skeletalMuscleMass: 32.0,
        leanBodyMass: 62.2,
        bodyFatPercentage: 19.6
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2024-12-22")!,
        weight: 75.9,
        height: 175.0,
        age: 31,
        bodyFatMass: 14.0,
        basalMetabolicRate: 1630,
        skeletalMuscleMass: 32.2,
        leanBodyMass: 62.5,
        bodyFatPercentage: 19.1
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2025-01-19")!,
        weight: 75.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 13.5,
        basalMetabolicRate: 1635,
        skeletalMuscleMass: 32.4,
        leanBodyMass: 62.7,
        bodyFatPercentage: 18.7
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2025-02-22")!,
        weight: 75.2,
        height: 175.0,
        age: 31,
        bodyFatMass: 13.0,
        basalMetabolicRate: 1640,
        skeletalMuscleMass: 32.6,
        leanBodyMass: 63.0,
        bodyFatPercentage: 18.2
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2025-03-18")!,
        weight: 74.9,
        height: 175.0,
        age: 31,
        bodyFatMass: 12.5,
        basalMetabolicRate: 1645,
        skeletalMuscleMass: 32.8,
        leanBodyMass: 63.2,
        bodyFatPercentage: 17.8
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2025-04-24")!,
        weight: 74.6,
        height: 175.0,
        age: 31,
        bodyFatMass: 12.0,
        basalMetabolicRate: 1650,
        skeletalMuscleMass: 33.0,
        leanBodyMass: 63.5,
        bodyFatPercentage: 17.3
      ),
      Inbody(
        // swiftlint:disable:next force_unwrapping
        date: formatter.date(from: "2025-05-30")!,
        weight: 74.3,
        height: 175.0,
        age: 31,
        bodyFatMass: 11.5,
        basalMetabolicRate: 1655,
        skeletalMuscleMass: 33.2,
        leanBodyMass: 63.7,
        bodyFatPercentage: 16.8
      )
    ]
  }
}
