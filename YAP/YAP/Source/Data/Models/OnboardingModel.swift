////
////  OnboardingModel.swift
////  YAP
////
////  Created by 여성일 on 6/4/25.
////
//
//import SwiftUI
//
//struct OnboardingItem: Identifiable {
//  let id = UUID()
//  var inbody: [InbodyInfoItem]
//  var activityInfo: ActivityInfoItem
//}
//
//struct InbodyInfoItem: Identifiable {
//  var id = UUID()
//  var type: InbodyInfoType
//  var value: Double
//  var unit: UnitType
//
//  var intValue: Int {
//    Int(value)
//  }
//}
//
//struct ActivityInfoItem {
//  var activityLevel: ActivityType?
//  var goalType: GoalType?
//  var mealCount: Int?
//}
//
//extension OnboardingItem {
//  static let initItem: OnboardingItem = OnboardingItem(
//    inbody: [
//      InbodyInfoItem(type: .age, value: 19.0, unit: .age),
//      InbodyInfoItem(type: .height, value: 150, unit: .cm),
//      InbodyInfoItem(type: .weight, value: 50.0, unit: .kg),
//      InbodyInfoItem(type: .basalMetabolicRate, value: 1500, unit: .kcal),
//      InbodyInfoItem(type: .skeletalMuscleMass, value: 25.0, unit: .kg),
//      InbodyInfoItem(type: .bodyFatMass, value: 25.0, unit: .kg),
//      InbodyInfoItem(type: .bodyFatPercentage, value: 25.0, unit: .percent),
//      InbodyInfoItem(type: .leanBodyMass, value: 0.0, unit: .kg)
//    ],
//    activityInfo: ActivityInfoItem(
//      activityLevel: nil,
//      goalType: nil,
//      mealCount: nil
//    )
//  )
//}
//
//extension OnboardingItem {
//  private var basalMetabolicRate: Double {
//    inbody.first(where: { $0.type == .basalMetabolicRate })?.value ?? 0.0
//  }
//
//  private var maintenanceCalories: Double {
//    let multiplier = activityInfo.activityLevel?.activityMultiplier ?? 1.2
//    return basalMetabolicRate * multiplier
//  }
//
//  var goalCalories: Int {
//    switch activityInfo.goalType {
//    case .diet:
//      return Int(maintenanceCalories - 423.5)
//    case .bulkUp:
//      return Int(maintenanceCalories + 100)
//    case .weightMaintain:
//      return Int(maintenanceCalories)
//    case .none:
//      return Int(maintenanceCalories)
//    }
//  }
//
//  static func from(aiData: [String]) -> [InbodyInfoItem] {
//    let types: [InbodyInfoType] = [
//      .age, .height, .weight, .basalMetabolicRate,
//      .skeletalMuscleMass, .bodyFatMass, .bodyFatPercentage, .leanBodyMass
//    ]
//
//    let units: [UnitType] = [
//      .age, .cm, .kg, .kcal, .kg, .kg, .percent, .kg
//    ]
//
//    var items: [InbodyInfoItem] = []
//
//    for (index, valueString) in aiData.enumerated() {
//      guard index < types.count,
//            let value = Double(valueString.trimmingCharacters(in: .whitespacesAndNewlines)) else { continue }
//
//      let item = InbodyInfoItem(type: types[index], value: value, unit: units[index])
//      items.append(item)
//    }
//
//    return items
//  }
//}

import Foundation

struct OnboardingModel: Identifiable {
  let id = UUID()
  var inbodyInfoItem: InbodyInfoItem
  var activityInfoItem: ActivityInfoItem
}

struct InbodyInfoItem: Identifiable {
  var id = UUID()
  var height: Double
  var weight: Double
  var age: Int
  var bodyFatMass: Double
  var bodyFatPercentage: Double
  var basalMetabolicRate: Double
  var skeletalMuscleMass: Double
  var leanBodyMass: Double
}

struct ActivityInfoItem {
  var activityLevel: ActivityType?
  var goalType: GoalType?
  var mealCount: Int?
}

struct CalorieRequirementsItem {
  var carbohydrates: Int // 탄수화물
  var protein: Int // 단백질
  var lipid: Int // 지방
  var calorie: Int // 요구 칼로리
}
