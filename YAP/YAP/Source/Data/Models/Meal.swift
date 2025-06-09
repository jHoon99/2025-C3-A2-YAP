//
//  Calorie.swift
//  YAP
//
//  Created by 여성일 on 5/30/25.
//

import Foundation
import SwiftData

@Model
class Meal {
  var day: Date // 날짜
  var carbohydrates: Double // 탄수화물
  var protein: Double // 단백질
  var lipid: Double // 지방
  var kcal: Int // 칼로리
  
  @Relationship(deleteRule: .cascade)
  var menus: [Menu]
  
  // MARK: - 끼니 구분을 위한 필드 추가
  var mealIndex: Int
  var isComplete: Bool = false
  
  // MARK: - 목표 칼로리 (동적 업데이트 위함)
  var targetKcal: Int
  var targetCarbs: Double
  var targetProtein: Double
  var targetFat: Double

  init(
    day: Date,
    carbohydrates: Double,
    protein: Double,
    lipid: Double,
    kcal: Int,
    menus: [Menu],
    mealIndex: Int,
    targetKcal: Int,
    targetCarbs: Double,
    targetProtein: Double,
    targetFat: Double
  ) {
    self.day = day
    self.carbohydrates = carbohydrates
    self.protein = protein
    self.lipid = lipid
    self.kcal = kcal
    self.menus = menus
    self.mealIndex = mealIndex
    self.targetKcal = targetKcal
    self.targetCarbs = targetCarbs
    self.targetProtein = targetProtein
    self.targetFat = targetFat
  }
}
