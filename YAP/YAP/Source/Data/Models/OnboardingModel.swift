//
//  OnboardingModel.swift
//  YAP
//
//  Created by 여성일 on 6/4/25.
//

import SwiftUI

struct OnboardingItem: Identifiable {
  let id = UUID()
  var inbody: [InbodyInfoItem]
  var activityInfo: ActivityInfoItem
}

struct InbodyInfoItem: Identifiable {
  var id = UUID()
  var type: InbodyInfoType
  var value: Double
  var unit: UnitType
  
  var intValue: Int {
    Int(value)
  }
}

struct ActivityInfoItem {
  var activityLevel: ActivityType?
  var goalType: GoalType?
  var mealCount: Int?
}

extension OnboardingItem {
  static let initItem: OnboardingItem = OnboardingItem(
    inbody: [
      InbodyInfoItem(type: .age, value: 19.0, unit: .age),
      InbodyInfoItem(type: .height, value: 130, unit: .cm),
      InbodyInfoItem(type: .weight, value: 0.0, unit: .kg),
      InbodyInfoItem(type: .basalMetabolicRate, value: 0, unit: .kcal),
      InbodyInfoItem(type: .skeletalMuscleMass, value: 0.0, unit: .kg),
      InbodyInfoItem(type: .bodyFatMass, value: 0.0, unit: .kg),
      InbodyInfoItem(type: .bodyFatPercentage, value: 0.0, unit: .percent),
      InbodyInfoItem(type: .leanBodyMass, value: 0.0, unit: .kg)
    ],
    activityInfo: ActivityInfoItem(
      activityLevel: nil,
      goalType: nil,
      mealCount: nil
    )
  )
}

extension OnboardingItem {
  private var basalMetabolicRate: Double {
    inbody.first(where: { $0.type == .basalMetabolicRate })?.value ?? 0.0
  }

  private var activityMultiplier: Double {
    switch activityInfo.activityLevel {
    case .littleActivity: return 1.2
    case .verylittleActivity: return 1.375
    case .middleActivity: return 1.55
    case .vigorousActivity: return 1.725
    case .veryVigorousActivity: return 1.9
    case .none: return 1.2
    }
  }

  private var maintenanceCalories: Double {
    basalMetabolicRate * activityMultiplier
  }

  var goalCalories: Int {
    switch activityInfo.goalType {
    case .diet:
      return Int(maintenanceCalories - 423.5)
    case .bulkUp:
      return Int(maintenanceCalories + 100)
    case .weightMaintain:
      return Int(maintenanceCalories)
    case .none:
      return Int(maintenanceCalories)
    }
  }
}
