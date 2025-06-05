//
//  NutritionUnit.swift
//  YAP
//
//  Created by 조재훈 on 6/4/25.
//

import Foundation

enum NutritionUnit: String, CaseIterable {
  case totalGram = "인분"
  case gram = "g"
}

enum NutritionType {
  case calorie
  case carbohydrate
  case protein
  case fat
}
