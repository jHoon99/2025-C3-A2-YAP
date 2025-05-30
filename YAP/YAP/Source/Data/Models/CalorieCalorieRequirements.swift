//
//  Calorie.swift
//  YAP
//
//  Created by 여성일 on 5/30/25.
//

import Foundation
import SwiftData

@Model
class CalorieCalorieRequirements {
  var carbohydrates: Double // 탄수화물
  var protein: Double // 단백질
  var lipid: Double // 지방
  var calorie: Int // 요구 칼로리
  
  init(
    carbohydrates: Double,
    protein: Double,
    lipid: Double,
    calorie: Int
  ) {
    self.carbohydrates = carbohydrates
    self.protein = protein
    self.lipid = lipid
    self.calorie = calorie
  }
}
