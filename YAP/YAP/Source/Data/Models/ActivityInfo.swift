//
//  ActivityInfo.swift
//  YAP
//
//  Created by 여성일 on 5/30/25.
//

import Foundation
import SwiftData

@Model
class ActivityInfo {
  var activityLevel: ActivityType // 활동 수준
  var goalWeight: Double // 목표 체중
  var goalType: GoalType // 목표 타입
  var mealCount: Int // 끼니 수
  
  init(
    activityLevel: ActivityType,
    goalWeight: Double,
    goalType: GoalType,
    mealCount: Int
  ) {
    self.activityLevel = activityLevel
    self.goalWeight = goalWeight
    self.goalType = goalType
    self.mealCount = mealCount
  }
}
